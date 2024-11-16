{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    fenix.url = "github:nix-community/fenix";
    naersk.url = "github:nix-community/naersk";
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
      naersk,
    }:
    let
      inherit (import ./nix/crosstools.nix) buildTargets eachCrossSystem;

      mkPkgs =
        buildSystem: targetSystem:
        import nixpkgs (
          {
            system = buildSystem;
          }
          // (
            if targetSystem == null then
              { }
            else
              {
                # The nixpkgs cache doesn't have any packages where cross-compiling has
                # been enabled, even if the target platform is actually the same as the
                # build platform (and therefore it's not really cross-compiling). So we
                # only set up the cross-compiling config if the target platform is
                # different.
                crossSystem.config = buildTargets.${targetSystem}.crossSystemConfig;
              }
          )
        );
    in
    {
      packages = eachCrossSystem (builtins.attrNames buildTargets) (
        buildSystem: targetSystem:
        let
          pkgs = mkPkgs buildSystem null;
          pkgsCross = mkPkgs buildSystem targetSystem;
          rustTarget = buildTargets.${targetSystem}.rustTarget;
          fenixPkgs = fenix.packages.${buildSystem};

          mkToolchain =
            fenixPkgs:
            fenixPkgs.toolchainOf {
              channel = "stable";
              sha256 = "sha256-yMuSb5eQPO/bHv+Bcf/US8LVMbf/G/0MSfiPwBhiPpk=";
            };

          toolchain = fenixPkgs.combine [
            (mkToolchain fenixPkgs).rustc
            (mkToolchain fenixPkgs).cargo
            (mkToolchain fenixPkgs.targets.${rustTarget}).rust-std
          ];

          buildPackageAttrs =
            if builtins.hasAttr "makeBuildPackageAttrs" buildTargets.${targetSystem} then
              buildTargets.${targetSystem}.makeBuildPackageAttrs pkgsCross
            else
              { };

          naersk' = pkgs.callPackage naersk {
            cargo = toolchain;
            rustc = toolchain;
          };
        in
        naersk'.buildPackage (
          buildPackageAttrs
          // rec {
            src = ./.;
            strictDeps = true;
            doCheck = false;

            CARGO_BUILD_TARGET = rustTarget;
            CARGO_BUILD_RUSTFLAGS = [
              # https://github.com/rust-lang/cargo/issues/4133
              "-C"
              "linker=${TARGET_CC}"
            ];

            # Required because ring crate is special. This also seems to have
            # fixed some issues with the x86_64-windows cross-compile :shrug:
            TARGET_CC = "${pkgsCross.stdenv.cc}/bin/${pkgsCross.stdenv.cc.targetPrefix}cc";

            OPENSSL_STATIC = "1";
            OPENSSL_LIB_DIR = "${pkgsCross.pkgsStatic.openssl.out}/lib";
            OPENSSL_INCLUDE_DIR = "${pkgsCross.pkgsStatic.openssl.dev}/include";
          }
        )
      );
    };
}

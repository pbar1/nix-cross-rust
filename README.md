# `nix-cross-rust`

Nix flake to cross-compile Rust projects. Uses Fenix for toolchains and Naersk
for incremental builds.

## Usage

Start your own flake using this one as a template:

```sh
nix flake init -t github:pbar1/nix-cross-rust
nix flake lock
```

## Flake Outputs

```
♪ nix flake show
git+file:///Users/pierce/code/nix-cross-rust?ref=refs/heads/main&rev=4028098b657ec2680e2c2e81145e1dfc5205aacf
└───packages
    ├───aarch64-darwin
    │   ├───cross-aarch64-darwin: package 'nix-cross-rust-0.1.0'
    │   ├───cross-aarch64-linux: package 'nix-cross-rust-0.1.0'
    │   ├───cross-x86_64-darwin: package 'nix-cross-rust-0.1.0'
    │   ├───cross-x86_64-linux: package 'nix-cross-rust-0.1.0'
    │   └───default: package 'nix-cross-rust-0.1.0'
    ├───aarch64-linux
    │   ├───cross-aarch64-darwin omitted (use '--all-systems' to show)
    │   ├───cross-aarch64-linux omitted (use '--all-systems' to show)
    │   ├───cross-x86_64-darwin omitted (use '--all-systems' to show)
    │   ├───cross-x86_64-linux omitted (use '--all-systems' to show)
    │   └───default omitted (use '--all-systems' to show)
    ├───x86_64-darwin
    │   ├───cross-aarch64-darwin omitted (use '--all-systems' to show)
    │   ├───cross-aarch64-linux omitted (use '--all-systems' to show)
    │   ├───cross-x86_64-darwin omitted (use '--all-systems' to show)
    │   ├───cross-x86_64-linux omitted (use '--all-systems' to show)
    │   └───default omitted (use '--all-systems' to show)
    └───x86_64-linux
        ├───cross-aarch64-darwin omitted (use '--all-systems' to show)
        ├───cross-aarch64-linux omitted (use '--all-systems' to show)
        ├───cross-x86_64-darwin omitted (use '--all-systems' to show)
        ├───cross-x86_64-linux omitted (use '--all-systems' to show)
        └───default omitted (use '--all-systems' to show)
```

## Timings

### System Info

```
♪ sysctl -a | grep -e machdep\.cpu -e memsize
hw.memsize: 17179869184
hw.memsize_usable: 16585523200
machdep.cpu.cores_per_package: 8
machdep.cpu.core_count: 8
machdep.cpu.logical_per_package: 8
machdep.cpu.thread_count: 8
machdep.cpu.brand_string: Apple M2
```

### Initial Toolchain Build

Initial cross-compile builds are very slow because almost nothing is cached in
public Nix caches. Once the first per target platform succeeded though,
subsequent builds will be fast.

- `aarch64-darwin` (native): omitted
- `aarch64-darwin` -> `aarch64-linux-musl`: 44m
- `aarch64-darwin` -> `x86_64-linux-musl`: 44m

### Real Project Clean Build

To test build speed in a real world scenario, I copy-pasted this flake into
[pbar1/astu](https://github.com/pbar1/astu) and then build it from scratch.

- `aarch64-darwin` (native): 2m44s
- `aarch64-darwin` -> `aarch64-linux-musl`: 2m53s
- `aarch64-darwin` -> `x86_64-linux-musl`: 5m20s

Not quite sure why `x86_64-linux-musl` was slower than the other two. I did run
it first, so maybe the extra time was spent downloading Rust crate sources that
were then able to be used in the other two builds?

## Resources

- [Statically Cross-Compiling Rust Projects Using Nix](https://mediocregopher.com/posts/x-compiling-rust-with-nix.gmi)
  - [Flake](https://code.betamike.com/micropelago/domani/src/commit/0ed265db6f349cece70de3c6fabd42dd07e9c589/flake.nix)
  - Really, go read that post. This flake is almost exactly that, subbing out
    the Windows bits for Darwin, and with less emphasis on static.
- [Naersk cross-windows](https://github.com/nix-community/naersk/blob/master/examples/cross-windows/flake.nix)
- [Nix.dev cross compilation](https://nix.dev/tutorials/cross-compilation.html)
- Target names
  - [Nix](https://github.com/NixOS/nixpkgs/blob/master/lib/systems/examples.nix)
  - [Rust](https://doc.rust-lang.org/nightly/rustc/platform-support.html)

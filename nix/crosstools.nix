rec {
  buildTargets = {
    "x86_64-linux" = {
      crossSystemConfig = "x86_64-unknown-linux-musl";
      rustTarget = "x86_64-unknown-linux-musl";
    };

    "aarch64-linux" = {
      crossSystemConfig = "aarch64-unknown-linux-musl";
      rustTarget = "aarch64-unknown-linux-musl";
    };

    "x86_64-darwin" = {
      crossSystemConfig = "x86_64-apple-darwin";
      rustTarget = "x86_64-apple-darwin";
    };

    "aarch64-darwin" = {
      crossSystemConfig = "aarch64-apple-darwin";
      rustTarget = "aarch64-apple-darwin";
    };
  };

  # eachSystem [system] (system: ...)
  #
  # Returns an attrset with a key for every system in the given array, with
  # the key's value being the result of calling the callback with that key.
  eachSystem =
    supportedSystems: callback:
    builtins.foldl' (overall: system: overall // { ${system} = callback system; }) { } supportedSystems;

  # eachCrossSystem [system] (buildSystem: targetSystem: ...)
  #
  # Returns an attrset with a key "$buildSystem.cross-$targetSystem" for
  # every combination of the elements of the array of system strings. The
  # value of the attrs will be the result of calling the callback with each
  # combination.
  #
  # There will also be keys "$system.default", which are aliases of
  # "$system.cross-$system" for every system.
  eachCrossSystem =
    supportedSystems: callback:
    eachSystem supportedSystems (
      buildSystem:
      builtins.foldl' (
        inner: targetSystem:
        inner
        // {
          "cross-${targetSystem}" = callback buildSystem targetSystem;
        }
      ) { default = callback buildSystem buildSystem; } supportedSystems
    );
}

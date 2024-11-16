# `nix-cross-rust`

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

## Resources

- [Statically Cross-Compiling Rust Projects Using Nix](https://mediocregopher.com/posts/x-compiling-rust-with-nix.gmi)
  - [Flake](https://code.betamike.com/micropelago/domani/src/commit/0ed265db6f349cece70de3c6fabd42dd07e9c589/flake.nix)

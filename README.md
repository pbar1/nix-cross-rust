Initial, very simple flake:

```
♪ nix flake show
git+file:///Users/pierce/code/nix-cross-rust?ref=refs/heads/main&rev=c8333d881a959e46ab2c03a4e60815351804dfe6
└───defaultPackage
    ├───aarch64-darwin: package 'nix-cross-rust-0.1.0'
    ├───aarch64-linux omitted (use '--all-systems' to show)
    ├───x86_64-darwin omitted (use '--all-systems' to show)
    └───x86_64-linux omitted (use '--all-systems' to show)
```

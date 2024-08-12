{ pkgs }:
pkgs.lib.attrsets.recurseIntoAttrs (                                # (1)
  pkgs.callPackage ./pkg.nix {}
)
# NOTE
# ----
# 1. Package scope. How to create one? Not mentioned in the official
# Nix docs it seems, but see
# - https://discourse.nixos.org/t/namespacing-scoping-a-group-of-packages/13782/4
# - https://github.com/NixOS/nixpkgs/commit/632c4f2c9ba1f88cd5662da7bedf2ca5f0cda4a9
#

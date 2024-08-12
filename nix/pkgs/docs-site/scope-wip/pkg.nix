#
# See `docs.md` for package documentation.
#
{
  pkgs, lib
}:
lib.makeScope pkgs.newScope (self: with self; {                # (1)
  git = callPackage ./mk-pkg.nix {};
  v1_0_1 = callPackage ./mk-pkg.nix {
    release = {
      version = "v1.0.1";
      rev = "6b534b1065f536a66921d29e8234140f9f6a7a8f";
      sha256 = lib.fakeSha256;
    };
  };
  v1_0_0 = callPackage ./mk-pkg.nix {
    release = {
      version = "v1.0.0";
      rev = "0db46d6e450efaf0025abcd544fec054b122f6e7";
      sha256 = lib.fakeSha256;
    };
  };
})
# NOTE
# ----
# 1. Package scope. How to create one? Not mentioned in the official
# Nix docs it seems, but see
# - https://discourse.nixos.org/t/namespacing-scoping-a-group-of-packages/13782/4
# - https://github.com/NixOS/nixpkgs/commit/632c4f2c9ba1f88cd5662da7bedf2ca5f0cda4a9
#

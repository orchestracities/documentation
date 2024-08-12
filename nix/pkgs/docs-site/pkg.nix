#
# See `docs.md` for package documentation.
#
{ pkgs }:
derivation {
  system = pkgs.system;
  name = "docs-site-pkg-group";                                # (1)
  builder = "";

  git = pkgs.callPackage ./mk-pkg.nix {};
  v1_0_1 = pkgs.callPackage ./mk-pkg.nix {
    release = {
      version = "v1.0.1";
      rev = "6b534b1065f536a66921d29e8234140f9f6a7a8f";
      sha256 = "sha256-wJPp856/LtUP70nzftVLWU1JomJI7gMXg8gBn0jIhFw=";
    };
  };
  v1_0_0 = pkgs.callPackage ./mk-pkg.nix {
    release = {
      version = "v1.0.0";
      rev = "0db46d6e450efaf0025abcd544fec054b122f6e7";
      sha256 = "sha256-Ekgx6zHJWVhkKb9/gHMzx36GGgN0GF7ReXfX/HQjIiA=";
    };
  };
}
# NOTE
# ----
# 1. Package scope. How to create one that works with Flakes?
# I've tried doing it the "proper" way, with a package scope, but
# that didn't work---see `scope-wip` dir. So I'm trying my luck w/
# an empty derivation which seems to work fine so far.
#

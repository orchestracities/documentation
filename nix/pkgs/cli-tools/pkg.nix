#
# See `docs.md` for package documentation.
#
{ pkgs, scripts }:
rec {

  tools = with pkgs; [
    bash
    coreutils
    curl
    git
    mkdocs
    python3
    scripts
  ];

  # Make a shell env with all the given programs.
  # Notice we also add the program paths to the derivation so you can
  # reference them later if needed. E.g. in NixOS
  #
  #    environment.systemPackages = pkgs.your-derivation.paths;
  #
  # See also NOTE (1) below.
  mkShell = name: paths: pkgs.buildEnv {
    inherit name paths;
  } // { inherit paths; };

  dev-shell = mkShell "dev-shell" tools;

}
# NOTE
# ----
# 1. `mkShell`. We roll out our own function to create a derivation to make
# programs available in the PATH when instantiated through `nix shell`. This
# is because the built-in `mkShell` only works with `nix develop`. See:
# - https://github.com/c0c0n3/nixie/wiki/Fiddling-about-with-Nix-dev-envs
#
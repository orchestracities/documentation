#
# Function to generate the Flake output for a given system.
#
{ # System label---e.g. "x86_64-linux", "x86_64-darwin", etc.
  system,
  # The Nix package set for the input system, possibly with
  # overlays from other Flakes bolted on.
  sysPkgs,
  ...
}:
let
  docs-site = import ./docs-site { pkgs = sysPkgs; };
  scripts = import ./scripts { pkgs = sysPkgs; };
  tools = import ./cli-tools { pkgs = sysPkgs; inherit scripts; };
in rec {
  packages.${system} = {
    default = tools.dev-shell;
    dev-shell = tools.dev-shell;
    inherit docs-site;
  };
}

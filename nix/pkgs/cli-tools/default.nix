{ pkgs, scripts }: pkgs.callPackage ./pkg.nix { inherit scripts; }

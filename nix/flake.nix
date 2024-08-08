{
  description = "Flake to build and develop orchestra cities docs.";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    nixie = {
      url = "github:c0c0n3/nixie";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixie }:
  let
    build = nixie.lib.flakes.mkOutputSetForCoreSystems nixpkgs;
    pkgs = build (import ./pkgs/mkSysOutput.nix);
  in
    pkgs;
}

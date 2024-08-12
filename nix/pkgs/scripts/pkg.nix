#
# See `docs.md` for package documentation.
#
{
  stdenv, lib, makeWrapper,
  bash, coreutils, git
}:
let
  inherit (lib) makeBinPath;
in stdenv.mkDerivation rec {
  pname = "scripts";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    bash coreutils git
  ];

  installPhase = ''
    install -Dm755 commands.sh $out/bin/oc

    wrapProgram $out/bin/oc --prefix PATH : '${makeBinPath buildInputs}'
  '';
}

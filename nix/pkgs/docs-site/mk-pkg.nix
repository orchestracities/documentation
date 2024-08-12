#
# Make a docs site package either from a GitHub release or from
# local source.
#
{
  stdenv, fetchFromGitHub, mkdocs,

  # Pass in release info, e.g.
  # { version = 'v1.0.0'; rev = 'v1.0.0'; sha256 = 'wada-wada'; }
  # If null, then set version to "git" and use local source.
  release ? null
}:
let
  version = if release == null
            then "git"
            else release.version;
  src = if release == null
        then ../../../.
        else fetchFromGitHub {
          owner = "orchestracities";
          repo = "documentation";
          rev = release.rev;
          sha256 = release.sha256;
        };
in stdenv.mkDerivation {
  pname = "docs-site";
  inherit version src;

  buildInputs = [ mkdocs ];

  buildPhase = ''
    mkdocs build
  '';

  installPhase = ''
    mkdir -p $out/docs
    cp -r site/* $out/docs
    tar czf $out/docs.tgz -C $out docs
  '';
}

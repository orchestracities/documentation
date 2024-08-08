#
# See `docs.md` for package documentation.
#
{
  stdenv, mkdocs
}:
stdenv.mkDerivation {
  pname = "docs-site";
  version = "2020-07-26";

  src = ../../../.;  # TODO: replace w/ GitHub when we have a release.

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

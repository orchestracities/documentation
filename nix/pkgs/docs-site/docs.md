Docs Site
---------
> Nix package docs.

This package builds the a MkDocs static site from the markdown source
in the `docs` directory. The static site files go in the `docs` output
directory and also get packaged in a `docs.tgz` tarball for extra
convenience---`docs` is also the root directory in the tarball.

Have a look at [pkg.nix][pkg] if you're interested in the Nix package
details.




[pkg]: ./pkg.nix

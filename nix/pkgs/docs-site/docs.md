Docs Site
---------
> Nix package docs.

This package builds the a MkDocs static site from the markdown source
in the `docs` directory. The static site files go in the `docs` output
directory and also get packaged in a `docs.tgz` tarball for extra
convenience---`docs` is also the root directory in the tarball.

We keep a few package versions out of convenience. The `docs-site`
Nix package is just a dummy package to group the actual package
versions. There's a `git` package which we build either from the
local source in you git repo if you build locally

```bash
$ cd nix
$ nix build .#docs-site.git
$ ls result
docs/     docs.tgz
```

or the current source in the master branch if you build remotely

```bash
$ nix build github:orchestracities/documentation?dir=nix#docs-site.git
$ ls result
docs/     docs.tgz
```

We also keep a few packages for some of the releases. These packages
always fetch the source as it was at a given git revision, regardless
of whether you build from your repo clone

```bash
$ cd nix
$ nix build .#docs-site.v1_0_1
$ ls result
docs/     docs.tgz
```

or remotely

```bash
$ nix build github:orchestracities/documentation?dir=nix#docs-site.v1.0.1
```

Have a look at [pkg.nix][pkg] if you're interested in the Nix package
details.




[pkg]: ./pkg.nix

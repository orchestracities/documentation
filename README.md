# Orchestra Cities

![OC Logo](docs/rsrc/OC_Logo_color-300x190.jpg)

**Orchestra Cities** is a data and IoT-driven solution that allows cities to
collaboratively develop and share Smart City Services using Open APIs and
Open Standards. Launched in 2018 by [Martel Innovate](https://www.martel-innovate.com),
Orchestra Cities was initially developed and tested with Antwerp and Helsinki
as a solution for the [Select4Cities](https://www.select4cities.eu/)
Pre-Commercial Procurement (PCP). Following the PCP, Martel further invested
on the platform for the benefit of its customers.


### Repository content

This repository hosts the source and build tools for Orchestra Cities'
documentation site.

The documentation consists of an introduction, where the most important
topics and ideas are briefly explained, and a tutorial, where the user
can get some hands-on experience of the most important platform features.

The documentation site source is in the `docs` folder and it gets fed
into MkDocs to build a static site. Nix provides reproducible, sand-boxed
and cross-platform development environments.


### Development environment

We use Nix to get proper, isolated and reproducible development
environments. This is a sort of virtual shell environment on steroids
which has in it all the tools you need with the right versions. Plus,
it doesn't pollute your machine with libraries that could break your
existing programs—everything gets installed in an isolated Nix store
directory and made available only in the Nix shell.

First off, you should install Nix and enable the Flakes extension

```bash
$ sh <(curl -L https://nixos.org/nix/install) --daemon
$ mkdir -p ~/.config/nix
$ echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

Now you can get into our Nix shell and use the tools you need to
develop: Bash, git, MkDocs, etc.

```bash
$ cd nix
$ nix shell
```


### Editing content

The documentation site source is in the `docs` folder. Write in plain
markdown. Use figures accordingly. Put images and binary resources
in `docs/rsrc`. Respect the naming schema of the files in there to
keep it reasonably organised.

You can build the documentation site and live edit it easily with
the `mkdocs` command. After getting into the Nix shell as explained
earlier, go back to the repository's root directory and run

```bash
$ mkdocs build
```

This will output the whole static site in the `site` directory—there's
a `.gitignore` file to keep this directory out of source control. To
see what the site looks like, run

```bash
$ mkdocs serve
```

and then browse to http://localhost:8000. If you edit files in the
`docs` directory, your changes should be reflected in the browser.


### Publishing the site

We build a static Web site and package it in a tarball. You should
be able to just extract the tarball in a suitable directory on a
Web server and serve the plain files in the extracted directory.
That's basically what we do to publish the documentation to our
Nginx machine serving `docs.orchestracities.com`.

How to get the tarball containing the static documentation site?
Either download it from a [GitHub Release][releases] or [build it
yourself][docs-site] with Nix. Even better, if you have a Nix-based
Web server setup, you could just import the `docs` directory of one
of our `docs-site` Nix packages, e.g. `docs-site.v1_0_0` for the
`v1.0.0` release or `docs-site.git` for the current content of the
master branch.




[docs-site]: ./nix/pkgs/docs-site/docs.md
[releases]: https://github.com/orchestracities/documentation/releases

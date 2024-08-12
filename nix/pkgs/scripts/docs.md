Scripts
-------
> Nix package docs.

This package makes some Bash scripts available as subcommands of
a main `oc` command. These subcommands are functions declared in
[commands.sh][commands] which [pkg.nix][pkg] bundles in a Bash
script taking care of including all the dependencies.




[commands]: ./commands.sh
[pkg]: ./pkg.nix

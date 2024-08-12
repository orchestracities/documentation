Nix Package Scope
-----------------
> or how the hell are you supposed to do it

I've tried creating a "proper" Nix package scope for `docs-site`.
See the two files in this dir. I didn't change `mkSysOutput.nix`
so the top-level package is the package scope:

```nix
  docs-site = import ./docs-site { pkgs = sysPkgs; };
```

But Nix complained loudly with:

```
error: expected a derivation
```

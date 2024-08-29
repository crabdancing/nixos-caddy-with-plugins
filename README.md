With thanks to @airone01 for [helping with getting this fully declarative](https://github.com/NixOS/nixpkgs/issues/14671#issuecomment-2316411251). Also, special thanks to @Nanotwerp -- the core pkg.nix for this nix flake was written by them (I think).

This repo uses a newer (and better) method than the 'manually call golang commands' one everyone's been using for awhile.

You can simply call `output.default.caddyWithPlugins`.

---

Q: Why is this helpful?
A: Lets you declaratively install plugins for Caddy with full reproducibility and abstracts away.
Q: 
With thanks to @airone01 for [helping with getting this fully declarative](https://github.com/NixOS/nixpkgs/issues/14671#issuecomment-2316411251). Also, special thanks to @Nanotwerp -- the core pkg.nix for this nix flake was written by them (I think).

This repo uses a newer (and better) method than the 'manually call golang commands' one everyone's been using for awhile.

You can simply call `output.default.caddyWithMany` if you want a default collection of plugins, or you can build your on by calling:

```
output.default.withPlugins {
  caddyModules = [
    # example module to integrate
    {
      name = "transform-encoder";
      repo = "github.com/caddyserver/transform-encoder";
      # the version is a git hash or revision
      version = "f627fc4f76334b7aef8d4ed8c99c7e2bcf94ac7d";
    }
  ];
  vendorHash = lib.fakeHash;
}
```

---

Q: Why is this helpful?
A: Lets you declaratively install plugins for Caddy with full reproducibility and abstracts away.
Q: 
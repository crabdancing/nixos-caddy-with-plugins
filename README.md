With thanks to @airone01 for [helping with getting this fully declarative](https://github.com/NixOS/nixpkgs/issues/14671#issuecomment-2316411251). Also, special thanks to @Nanotwerp -- the core pkg.nix for this nix flake was [written by them (I think)](https://raw.githubusercontent.com/Nanotwerp/nixpkgs/caddy-rebase/pkgs/by-name/ca/caddy/package.nix).

This repo uses a newer (and better) method than the 'manually call golang commands' one everyone's been using for awhile.

You can simply call `packages.${pkgs.system}.caddyWithMany` if you want a default collection of plugins, or you can build your on by calling:

```nix
packages.${pkgs.system}.default.withPlugins {
  caddyModules = [
    # example module to integrate
    {
      name = "transform-encoder";
      repo = "github.com/caddyserver/transform-encoder";
      # the version is a git hash or revision
      version = "f627fc4f76334b7aef8d4ed8c99c7e2bcf94ac7d";
    }
  ];
  # Change to actual hash once build fails with hash error
  vendorHash = lib.fakeHash;
}
```

I built this for my personal use, but if you have any problems with it, feel free to open an issue. I also accept PRs if you want to improve stuff. I don't know if this repo will really be relevant in 3 months, but for the moment it's kinda useful to have. :)
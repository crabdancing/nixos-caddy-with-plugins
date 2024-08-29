{
  description = "Trying to build caddy with plugins declaratively for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      lib = pkgs.lib;
      caddyWithPlugins = pkgs.callPackage ./pkg.nix {};
    in let
      # Caddy Layer4 modules
      l4CaddyModules = lib.lists.map (name: {
        inherit name;
        repo = "github.com/mholt/caddy-l4";
        version = "3d22d6da412883875f573ee4ecca3dbb3fdf0fd0";
      }) ["layer4" "modules/l4proxy" "modules/l4tls" "modules/l4proxyprotocol"];
    in {
      packages.default = caddyWithPlugins;
      packages.baseCaddy = caddyWithPlugins.withPlugins {caddyModules = [];};
      packages.caddyWithL4 = caddyWithPlugins.withPlugins {
        caddyModules = l4CaddyModules;
        # vendorHash = "sha256-cpRtLb81BLu6kJqYBVc02/xOK42fjoOn7rokY8hzXgM=";
        vendorHash = "sha256-Bz2tR1/a2okARCWFEeSEeVUx2mdBe0QKUh5qzKUOF8s=";
      };
      caddyWithMany = caddyWithPlugins.withPlugins {
        caddyModules =
          [
            {
              name = "transform-encoder";
              repo = "github.com/caddyserver/transform-encoder";
              version = "f627fc4f76334b7aef8d4ed8c99c7e2bcf94ac7d";
            }
            {
              name = "connegmatcher";
              repo = "github.com/mpilhlt/caddy-conneg";
              version = "v0.1.4";
            }
          ]
          ++ l4CaddyModules;
        vendorHash = "sha256-OjyJdcbLMSvgkHKR4xMF0BgsuA5kdKgDgV+ocuNHUf4=";
      };
    });
}

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
      caddyWithL4 = caddyWithPlugins.override {
        externalPlugins =
          [
            {
              name = "transform-encoder";
              repo = "github.com/caddyserver/transform-encoder";
              version = "58ebafa572d531b301fdbc6e2fd139766bac7e8d";
            }
            {
              name = "connegmatcher";
              repo = "github.com/mpilhlt/caddy-conneg";
              version = "v0.1.4";
            }
          ]
          ++ (
            # Caddy Layer4 modules
            lib.lists.map (name: {
              inherit name;
              repo = "github.com/mholt/caddy-l4";
              version = "f3a880d4c01c884f4a096ccceb6c6d1e2d1d983d";
            }) ["layer4" "modules/l4proxy" "modules/l4tls" "modules/l4proxyprotocol"]
          );
        # vendorHash = "sha256-7cRI65foALEsfYhvdGresq7oma/cIsnVtbq+Gan5DCU=";
        vendorHash = "sha256-jF+g3Vu+T92sotReOpskT07YPG+UdW+1pDsa+z4p0Y4=";
      };
    in {
      inherit caddyWithPlugins caddyWithL4;
      packages.default = caddyWithL4;
    });
}

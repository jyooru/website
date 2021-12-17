{
  description = "Website development environment";

  inputs = {
    dotfiles.url = "github:jyooru/dotfiles";
    flake-utils.follows = "dotfiles/flake-utils";
    nixpkgs.follows = "dotfiles/nixpkgs";
  };

  outputs = { self, dotfiles, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.node-packages ];
        };

        packages = (with pkgs; [ git ] ++ (with nodePackages; [
          nodePackages."normalize.css"
          nodePackages."@11ty/eleventy"
          nodePackages."@11ty/eleventy-cache-assets"
          html-minifier
          sass
          simple-git
          nodePackages."terminal.css"
          ttf2woff2
        ]));
      in
      with pkgs;
      rec {
        apps = {
          build = writeShellApplication { runtimeInputs = packages; name = "eleventy-build"; text = "eleventy"; };
          serve = writeShellApplication { runtimeInputs = packages; name = "eleventy-serve"; text = "eleventy --serve"; };
          watch = writeShellApplication { runtimeInputs = packages; name = "eleventy-watch"; text = "eleventy --watch"; };
        };
        defaultApp = apps.serve;

        devShell = mkShell {
          inherit packages;
        };
      }
    );
}

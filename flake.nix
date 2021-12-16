{
  description = "Website development environment";

  inputs = {
    dotfiles.url = "github:jyooru/dotfiles";
  };

  outputs = { self, dotfiles }:
    let
      flake-utils = dotfiles.inputs.flake-utils;
      nixpkgs = dotfiles.inputs.nixpkgs;
    in

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
      rec {
        devShell = pkgs.mkShell { inherit packages; };
      }
    );
}

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
        packages = (with pkgs; [ git ] ++ nodeModules);
        nodeModules = (with pkgs; with nodePackages; [
          nodePackages."normalize.css"
          nodePackages."@11ty/eleventy"
          nodePackages."@11ty/eleventy-cache-assets"
          html-minifier
          sass
          simple-git
          nodePackages."terminal.css"
          ttf2woff2
        ]);
        nodePath = builtins.concatStringsSep ":" (map (x: toString x + "/lib/node_modules") nodeModules);
      in
      with pkgs;
      rec {
        apps = {
          build = writeShellApplication { runtimeInputs = packages; name = "eleventy-build"; text = "NODE_PATH=${nodePath} eleventy"; };
          serve = writeShellApplication { runtimeInputs = packages; name = "eleventy-serve"; text = "NODE_PATH=${nodePath} eleventy --serve"; };
          watch = writeShellApplication { runtimeInputs = packages; name = "eleventy-watch"; text = "NODE_PATH=${nodePath} eleventy --watch"; };
        };
        defaultApp = apps.serve;

        devShell = mkShell {
          inherit packages;
        };

        defaultPackage = stdenv.mkDerivation {
          pname = "website";
          version = "2.1.0";

          src = ./.;

          nativeBuildInputs = [ apps.build dotfiles.packages.${system}.nerdfonts-woff2-firacode ];

          buildPhase = ''
            export REPRODUCIBLE_BUILD=1
            ${builtins.readFile (apps.build + "/bin/eleventy-build")}
          '';

          installPhase = ''
            mkdir -p "$out"
            cp -r dist/* "$out"
            cp -r "${dotfiles.packages.${system}.nerdfonts-woff2-firacode}/share/fonts/NerdFonts/woff2" "$out/fonts/"
          '';
        };
      }
    );
}

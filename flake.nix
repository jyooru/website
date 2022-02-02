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
        inherit (builtins) concatStringsSep getAttr listToAttrs toJSON;

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.nodePackages ];
        };
        nodePackagesNames = [
          "normalize.css"
          "@11ty/eleventy"
          "html-minifier"
          "sass"
          "terminal.css"
        ];
        nodePackages = map (x: getAttr x pkgs.nodePackages) nodePackagesNames;

        shellHook = ''
          export NODE_PATH=${concatStringsSep ":" (map (x: toString x + "/lib/node_modules") nodePackages)}
          export NODE_MODULES=${pkgs.lib.escapeShellArg (toJSON (listToAttrs (map (name: { inherit name; value = toString (getAttr name pkgs.nodePackages) + "/lib/node_modules"; }) nodePackagesNames)))}
        '';
        fontPath = "${dotfiles.packages.${system}.nerdfonts-woff2-firacode}/share/fonts/NerdFonts/woff2";
        preBuild = ''
          ${shellHook}

          [ -e dist ] && rm -rf dist
          mkdir -p "dist/assets/fonts"
          cp "${fontPath}/Fira Code Regular Nerd Font Complete.woff2" "dist/assets/fonts/fira-code-regular-nerd-font.woff2"
          cp "${fontPath}/Fira Code Bold Nerd Font Complete.woff2" "dist/assets/fonts/fira-code-bold-nerd-font.woff2"
        '';
      in
      with pkgs;
      rec {
        apps.serve = writeShellApplication { runtimeInputs = nodePackages; name = "serve"; text = "${preBuild} eleventy --serve"; };
        defaultApp = apps.serve;

        devShell = mkShell {
          packages = nodePackages;
          inherit shellHook;
        };

        packages.website = stdenv.mkDerivation {
          pname = "website";
          version = "2.1.0";

          src = ./.;

          nativeBuildInputs = nodePackages;

          buildPhase = ''
            ${preBuild}
            eleventy
          '';

          installPhase = ''
            mkdir $out
            cp -r dist/* "$out"
          '';
        };
        defaultPackage = packages.website;
      }
    );
}

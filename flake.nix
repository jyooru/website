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
        packages = (with pkgs; [ git ]) ++ nodePackages;
        nodePackagesStrings = [
          "normalize.css"
          "@11ty/eleventy"
          "@11ty/eleventy-cache-assets"
          "html-minifier"
          "sass"
          "simple-git"
          "terminal.css"
          "ttf2woff2"
        ];
        nodePackages = map (x: builtins.getAttr x pkgs.nodePackages) nodePackagesStrings;
        nodePath = builtins.concatStringsSep ":" (map (x: toString x + "/lib/node_modules") nodePackages);
        nodeModules = builtins.listToAttrs (map (name: { inherit name; value = toString (builtins.getAttr name pkgs.nodePackages) + "/lib/node_modules"; }) nodePackagesStrings);
        environmentVariables = "NODE_PATH=${nodePath} NODE_MODULES=${pkgs.lib.escapeShellArg (builtins.toJSON nodeModules)}";
        fontPath = "${dotfiles.packages.${system}.nerdfonts-woff2-firacode}/share/fonts/NerdFonts/woff2";
      in
      with pkgs;
      rec {
        apps = let prepareDistFolder = ''
          rm -rf dist
          mkdir -p "dist/assets/fonts"
          cp "${fontPath}/Fira Code Regular Nerd Font Complete.woff2" "dist/assets/fonts/fira-code-regular-nerd-font.woff2"
          cp "${fontPath}/Fira Code Bold Nerd Font Complete.woff2" "dist/assets/fonts/fira-code-bold-nerd-font.woff2"
        ''; in
          {
            build = writeShellApplication { runtimeInputs = packages; name = "eleventy-build"; text = "${prepareDistFolder} ${environmentVariables} eleventy"; };
            serve = writeShellApplication { runtimeInputs = packages; name = "eleventy-serve"; text = "${prepareDistFolder} ${environmentVariables} eleventy --serve"; };
            watch = writeShellApplication { runtimeInputs = packages; name = "eleventy-watch"; text = "${prepareDistFolder} ${environmentVariables} eleventy --watch"; };
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
            ${apps.build + "/bin/eleventy-build"}
          '';

          installPhase = ''
            mkdir -p "$out/assets/fonts"
            cp -r dist/* "$out"
          '';
        };
      }
    );
}

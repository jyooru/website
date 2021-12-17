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
        rawNodeModules = [
          "normalize.css"
          "@11ty/eleventy"
          "@11ty/eleventy-cache-assets"
          "html-minifier"
          "sass"
          "simple-git"
          "terminal.css"
          "ttf2woff2"
        ];
        nodeModules = map (x: builtins.getAttr x pkgs.nodePackages) rawNodeModules;
        nodePath = builtins.concatStringsSep ":" (map (x: toString x + "/lib/node_modules") nodeModules);
        nodePathSet = builtins.listToAttrs (map (name: { inherit name; value = toString (builtins.getAttr name pkgs.nodePackages) + "/lib/node_modules"; }) rawNodeModules);
        environmentVariables = "NODE_PATH=${nodePath} NODE_PATH_SET=${pkgs.lib.escapeShellArg (builtins.toJSON nodePathSet)}";
      in
      with pkgs;
      rec {
        apps = {
          build = writeShellApplication { runtimeInputs = packages; name = "eleventy-build"; text = "${environmentVariables} eleventy"; };
          serve = writeShellApplication { runtimeInputs = packages; name = "eleventy-serve"; text = "${environmentVariables} eleventy --serve"; };
          watch = writeShellApplication { runtimeInputs = packages; name = "eleventy-watch"; text = "${environmentVariables} eleventy --watch"; };
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

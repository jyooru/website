{
  description = "Website development environment";

  inputs = {
    dotfiles.url = "github:jyooru/dotfiles";
    flake-utils.follows = "dotfiles/flake-utils";
    nixpkgs.follows = "dotfiles/nixpkgs";
  };

  outputs = { self, dotfiles, flake-utils, nixpkgs }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        inherit (builtins) attrValues concatStringsSep getAttr listToAttrs mapAttrs toFile toJSON;

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ dotfiles.overlays.nodePackages ];
        };

        nodePackageSet = listToAttrs (map (name: { inherit name; value = getAttr name pkgs.nodePackages; }) [
          "@11ty/eleventy"
          "html-minifier"
          "normalize.css"
          "sass"
          "terminal.css"
        ]);
        nodePackages = attrValues nodePackageSet;
        nodeModules = mapAttrs (_: value: "${value}/lib/node_modules") nodePackageSet;
        NODE_MODULES = toJSON nodeModules;
        NODE_PATH = concatStringsSep ":" (attrValues nodeModules);
      in
      with pkgs;
      rec {
        defaultApp = apps.server;
        apps.server =
          let
            config = toFile "Caddyfile" ''
              :8080 {
                root result
                file_server
                try_files {path} {path}.html {path}/
              }
            '';
          in
          writeShellApplication {
            runtimeInputs = [ caddy ];
            name = "server";
            text = "caddy run -adapter caddyfile -config ${config}";
          };

        devShell = mkShell {
          packages = nodePackages;
          inherit NODE_PATH NODE_MODULES;
        };

        defaultPackage = packages.website;
        packages.website =
          let
            srcs = {
              fonts = "${dotfiles.packages.${system}.nerdfonts-woff2-firacode}/share/fonts/NerdFonts/woff2";
              website = ./.;
            };
          in
          stdenv.mkDerivation {
            pname = "website";
            version = "2.1.0";

            src = srcs.website;

            inherit NODE_PATH NODE_MODULES;

            nativeBuildInputs = nodePackages;

            buildPhase = ''
              mkdir -p src/assets/fonts
              cp "${srcs.fonts}/Fira Code Regular Nerd Font Complete.woff2" src/assets/fonts/fira-code-regular-nerd-font.woff2
              cp "${srcs.fonts}/Fira Code Bold Nerd Font Complete.woff2" src/assets/fonts/fira-code-bold-nerd-font.woff2

              eleventy
            '';

            installPhase = ''
              mkdir $out
              cp -r dist/* $out
            '';
          };
      }
    );
}

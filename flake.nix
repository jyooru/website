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
        pkgs = import nixpkgs { inherit system; };

        nodePackages = with pkgs; stdenv.mkDerivation {
          name = "node-packages";

          src = lib.cleanSourceWith {
            filter = (path: type:
              type == "regular" &&
              builtins.any (x: baseNameOf path == x) [ "package.json" "package-lock.json" ]
            );
            src = ./.;
          };

          nativeBuildInputs = [ pkgs.nodePackages.node2nix ];

          buildPhase = ''
            node2nix -d -l package-lock.json
          '';

          installPhase = ''
            mkdir $out
            cp ./* $out
          '';
        };
        node = import nodePackages { inherit pkgs system; inherit (pkgs) nodejs; };
        nodeScript = (script: pkgs.writeShellScriptBin
          "node-script-${script}"
          (builtins.replaceStrings
            [ "exec ${pkgs.stdenv.shell}" ]
            [ "exec ${pkgs.nodejs}/bin/npm run ${script}" ]
            (builtins.readFile (toString node.shell + "/bin/shell"))
          )
        );

        inherit (node.args) name version;
      in
      with pkgs;
      rec {
        apps = builtins.listToAttrs (map (name: { inherit name; value = nodeScript name; }) [
          "build"
          "serve"
          "watch"
        ]);
        defaultApp = apps.serve;

        devShell = node.shell;

        packages = {
          inherit nodePackages;
        };
      }
    );
}

{
  description = "Website development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils }:
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
      in
      with pkgs;
      {
        devShell = node.shell;

        packages = {
          inherit nodePackages;
        };
      }
    );
}

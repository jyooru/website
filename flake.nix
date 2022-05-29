{
  inputs = {
    dotfiles.url = "github:jyooru/dotfiles";
    utils.follows = "dotfiles/utils";
    nixpkgs.follows = "dotfiles/nixpkgs";
  };

  outputs = { self, dotfiles, utils, nixpkgs } @ inputs:
    with nixpkgs.lib;
    with utils.lib;

    mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];
      sharedOverlays = [ dotfiles.overlays.nodePackages ];

      outputsBuilder = channels:
        with channels.nixpkgs;

        let
          pkgs = channels.nixpkgs;

          inputs = [ zola ] ++ attrValues modules;
        in

        rec {
          defaultApp = apps.serve;
          apps = {
            link = writeShellApplication {
              name = "link";
              runtimeInputs = inputs;
              text = ''
                mkdir -p modules
                ${forModule (name: path: "unlink modules/${name} || true")}
                ${forModule (name: path: "ln -s ${path} modules/${name}")}
              '';
            };
            serve = writeShellApplication {
              name = "serve";
              runtimeInputs = inputs;
              text = "${apps.link}/bin/link; zola serve";
            };
          };

          devShell = mkShell { packages = [ zola ]; };

          defaultPackage = packages.website;
          packages = modules // {
            website = stdenv.mkDerivation {
              name = "website";
              src = ./.;
              buildInputs = inputs;
              buildPhase = ''
                mkdir modules
                ${forModule (name: path: "cp -r ${path} modules/${name}")}
                zola build
              '';
              installPhase = ''
                cp -r public $out
              '';
            };
          };
        };
    };
}

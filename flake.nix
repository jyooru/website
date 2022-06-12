{
  inputs = {
    utils.follows = "dotfiles/utils";
    nixpkgs.follows = "dotfiles/nixpkgs";

    dotfiles.url = "github:jyooru/dotfiles";
    minecraft-server-discord-status.url = "github:jyooru/minecraft-server-discord-status";
    nix-minecraft-servers.url = "github:jyooru/nix-minecraft-servers";
    pearson-pdf.url = "github:jyooru/pearson-pdf";
    pins.url = "github:jyooru/pins";
    wigle-csv.url = "github:jyooru/wigle-csv";
    yggpp.url = "github:jyooru/yggpp";
  };

  outputs = { self, utils, nixpkgs, ... } @ inputs:
    with nixpkgs.lib;
    with utils.lib;

    mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      outputsBuilder = channels:
        with channels.nixpkgs;
        rec {
          apps = rec {
            default = serve;
            serve = {
              type = "app";
              program = toString (writeShellScript "serve" "exec ${zola}/bin/zola serve");
            };
          };

          devShells = rec {
            default = website;
            website = mkShell {
              packages = [
                packages.make-relative
                zola
              ];
            };
          };

          packages = import ./packages {
            inherit inputs;
            pkgs = channels.nixpkgs;
          };
        };
    };
}

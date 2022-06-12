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

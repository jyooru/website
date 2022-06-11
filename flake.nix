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
        let buildInputs = [ zola ]; in
        rec {
          apps = rec {
            default = serve;
            serve = {
              type = "app";
              program = toString (writeShellScript "serve" "${zola}/bin/zola serve");
            };
          };

          devShells = rec {
            default = website;
            website = mkShell { packages = buildInputs; };
          };

          packages = rec {
            default = website;
            website = stdenv.mkDerivation {
              pname = "website";
              version = self.lastModifiedDate;

              src = ./.;

              inherit buildInputs;

              buildPhase = ''
                runHook preBuild
              
                zola build

                runHook postBuild
              '';

              preInstall = ''
                cp public/404.html public/ipfs-404.html
              '';

              installPhase = ''
                runHook preInstall

                cp -r public $out

                runHook postInstall
              '';
            };
          };
        };
    };
}

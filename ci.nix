let
  inherit (builtins) currentSystem getFlake;
  inherit (flake) inputs;
  inherit (pkgs) lib;
  inherit (lib) recurseIntoAttrs;

  flake = getFlake (toString ./.);
  pkgs = import inputs.nixpkgs { inherit system; };
  system = currentSystem;
in
{
  apps = recurseIntoAttrs flake.apps.${system};
  devShell = flake.devShell.${system};
  packages = recurseIntoAttrs flake.packages.${system};
}

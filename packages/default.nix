{ inputs, pkgs }:

with pkgs;

rec {
  default = website;

  make-relative = callPackage ./make-relative { };

  website = callPackage ./website {
    inherit make-relative;
    inherit (inputs) self;
  };
}

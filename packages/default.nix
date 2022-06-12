{ inputs, pkgs }:

with pkgs;

rec {
  default = website;

  make-relative = callPackage ./make-relative { };

  nerdfonts-woff2 = callPackage ./nerdfonts-woff2 {
    inherit ttf2woff2; nerdfonts = nerdfonts.override { fonts = [ "FiraCode" ]; };
  };

  # TODO: ttf2woff2 is a nodejs wrapper for https://github.com/google/woff2
  # use woff2 instead
  ttf2woff2 = callPackage ./ttf2woff2 { };

  website = callPackage ./website { inherit inputs make-relative nerdfonts-woff2; };
}

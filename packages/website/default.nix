{ lib, stdenv, self, make-relative, nerdfonts, nerdfonts-woff2, zola }:

with lib;

let
  fonts = nerdfonts-woff2.override {
    nerdfonts = nerdfonts.override { fonts = [ "FiraCode" ]; };
  };
  copyFonts = concatStringsSep "\n" (map
    (font: "cp '${fonts}/share/fonts/woff2/${font}' 'assets/fonts/${replaceStrings [" "] ["-"] (toLower font)}'")
    [ "Fira Code Regular Nerd Font Complete.woff2" "Fira Code Bold Nerd Font Complete.woff2" ]
  );
in

stdenv.mkDerivation {
  pname = "website";
  version = self.lastModifiedDate;

  src = ../..;

  buildInputs = [ make-relative zola ];

  buildPhase = ''
    runHook preBuild
              
    zola build
    pushd public
    make-relative ${(importTOML ../../config.toml).base_url}
    mkdir -p assets/fonts
    pwd
    ${copyFonts}
    popd

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

  meta = with lib;{
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}

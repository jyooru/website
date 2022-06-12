{ lib, stdenv, self, make-relative, zola }:

with lib;

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
}

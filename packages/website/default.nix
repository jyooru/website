{ inputs, lib, stdenv, make-relative, nerdfonts, nerdfonts-woff2, python3, zola }:

with lib;

let
  config = importTOML ../../config.toml;

  fonts = nerdfonts-woff2.override {
    nerdfonts = nerdfonts.override { fonts = [ "FiraCode" ]; };
  };
  copyFonts = concatStringsSep "\n" (map
    (font: "cp '${fonts}/share/fonts/woff2/${font}' 'static/assets/fonts/${replaceStrings [" "] ["-"] (toLower font)}'")
    [ "Fira Code Regular Nerd Font Complete.woff2" "Fira Code Bold Nerd Font Complete.woff2" ]
  );

  projects = removeAttrs inputs (config.extra.projects.ignore ++ [ "self" ]);
  copyProjects = concatStringsSep "\n" (attrValues (mapAttrs
    (name: value:
      let out = "content/projects/${name}"; in
      ''
        if [ -e ${value}/docs ]; then
          cp -r --no-preserve=mode ${value}/docs ${out}
        else
          mkdir -p ${out}
          if [ -e ${value}/README.md ]; then
            cp --no-preserve=mode ${value}/README.md ${out}
          fi
        fi
      '')
    projects
  ));
in

stdenv.mkDerivation {
  pname = "website";
  version = inputs.self.lastModifiedDate;

  src = ../..;

  buildInputs = [
    make-relative
    (python3.withPackages (ps: [ ps.python-frontmatter ]))
    zola
  ];

  buildPhase = ''
    runHook preBuild

    ${copyProjects}
    python packages/website/projects.py

    mkdir -p static/assets/fonts
    ${copyFonts}
    
    zola build

    pushd public
    make-relative ${config.base_url}
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

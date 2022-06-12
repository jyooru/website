{ lib, mkYarnPackage, fetchFromGitHub }:

mkYarnPackage rec {
  pname = "make-relative";
  version = "20221226";

  src = fetchFromGitHub {
    owner = "tmcw";
    repo = pname;
    rev = "bc6475fde56de5da366412a34c585e8530341909";
    hash = "sha256-i/PcLiZJCwzzFFwG1BxbvdH/ETnBsFAqeKRdkUqqYMA=";
  };
  packageJSON = "${src}/package.json";
  yarnLock = "${src}/yarn.lock";
}

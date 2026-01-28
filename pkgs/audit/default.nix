{ lib
, writeShellApplication
, fetchFromGitHub
, diffutils
, rev ? "af559d367a9ff45e6e0f8c5b214d12dfa6ac4155" 
, srcB
}: let
  srcA = fetchFromGitHub {
    owner = "nixos";
    repo = "nixpkgs";
    rev = rev;
    sha256 = "sha256-FW1bq43LRGMwA+SNoe64fMsM19/5QS+8rwfECmiukxk=";
  };
in writeShellApplication {
  name = "audit";
  runtimeInputs = [ diffutils ];

  text = ''
    diff -u ${srcA}/pkgs/applications/blockchains/bitcoin-knots/default.nix ${srcB}
  '';
}

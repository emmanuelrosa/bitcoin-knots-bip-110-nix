{ lib
, writeShellApplication
, fetchurl
, diffutils
, rev ? "af559d367a9ff45e6e0f8c5b214d12dfa6ac4155" 
, srcB
}: let
  srcA = fetchurl {
    url = "https://github.com/nixos/nixpkgs/raw/${rev}/pkgs/applications/blockchains/bitcoin-knots/default.nix";
    hash = "sha256-j2J4Y5bGUjTK1+gf7hqJDyMBO4xXSlP+nQZG9EUNW2o=";
  };
in writeShellApplication {
  name = "audit";
  runtimeInputs = [ diffutils ];

  text = ''
    diff -u ${srcA} ${srcB}
  '';
}

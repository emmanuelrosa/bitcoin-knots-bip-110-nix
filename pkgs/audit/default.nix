{ lib
, writeShellApplication
, fetchurl
, diffutils
, rev ? "a1527c52355063709233c891e58ffc7567b62368" 
, srcB
}: let
  srcA = fetchurl {
    url = "https://github.com/nixos/nixpkgs/raw/${rev}/pkgs/applications/blockchains/bitcoin-knots/default.nix";
    hash = "sha256-nzJHHm2n39ZJZ0PJu+F10Ddpx35mIcvQjCbKMXrkVmw=";
  };
in writeShellApplication {
  name = "audit";
  runtimeInputs = [ diffutils ];

  text = ''
    diff -u ${srcA} ${srcB}
  '';
}

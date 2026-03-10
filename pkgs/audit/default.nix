{ lib
, stdenvNoCC
, runCommand
, writeTextFile
, fetchurl
, fetchFromGitHub
, diffutils
, gnutar
, rev ? "6d3b61b190a899042ce82a5355111976ba76d698" 
, nixSrcB
, bitcoind-knots-bip-110
}: let
  mkDiff = srcA: srcB: runCommand "make-diff" {
    nativeBuildInputs = [ diffutils ]; 
  } ''
    diff -u -r ${srcA} ${srcB} > $out || true
  '';

  nixSrcA = fetchurl {
    url = "https://github.com/nixos/nixpkgs/raw/${rev}/pkgs/applications/blockchains/bitcoin-knots/default.nix";
    hash = "sha256-4srrBvnyujD1CARRcqETta2ZtX1o2DdAfuqUlFv6gEs=";
  };

  bitcoin-knots = fetchFromGitHub {
    owner = "bitcoinknots";
    repo = "bitcoin";
    rev = "a9aee730466ac67d35a3c03ee24676be5e045878";
    sha256 = "sha256-ISsQRuAw1f7HBDXbIvxvjvmGft3ABjK+Zl5gBokvjBA=";
  };

  bitcoin-knots-bip-110-extracted = runCommand "extracted-bitcoin-knots-bip-110" {
    nativeBuildInputs = [ gnutar ]; 
  } ''
    mkdir -p $out
    tar --strip-components=1 -xzf ${bitcoind-knots-bip-110.src} -C $out
  '';

  bitcoin-knots-bip-110-pr = fetchFromGitHub {
    owner = "dathonohm";
    repo = "bitcoin";
    rev = "a8e9e0e44cf29d31ec784f4d82cf0359120b17fb";
    sha256 = "sha256-vlRwXQu6b6xrI+NZtOi9h3VqVs2hF3IJMrh2L79PlwA=";
  };

  readme = writeTextFile {
    name = "README.md";
    text = ''
      - *package.diff* - The difference between the bitcoin-knots Nix package from Nixpkgs and the copy in this repo; `diff -u ${nixSrcA} ${nixSrcB}`
      - *pr.diff* - The difference between bitcoin-knots and the BIP-110 PR (https://github.com/bitcoinknots/bitcoin/pull/238)[https://github.com/bitcoinknots/bitcoin/pull/238]; diff -u -r ${bitcoin-knots} ${bitcoin-knots-bip-110-pr}
      - *bip110-client.diff* - The difference between bitcoin-knots and the BIP-110 UASF client; diff -u -r ${bitcoin-knots} ${bitcoin-knots-bip-110-extracted}; 
      - *branding.diff* - The difference between the bitcoin-knots BIP-110 PR and the BIP-110 UASF client. Should only contain branding-related changes; diff -u -r ${bitcoin-knots-bip-110-pr} ${bitcoin-knots-bip-110-extracted}
    '';
  };

  packageDiff = mkDiff nixSrcA nixSrcB;
  prDiff = mkDiff bitcoin-knots bitcoin-knots-bip-110-pr;
  bip110ClientDiff = mkDiff bitcoin-knots bitcoin-knots-bip-110-extracted;
  brandingDiff = mkDiff bitcoin-knots-bip-110-pr bitcoin-knots-bip-110-extracted;
in stdenvNoCC.mkDerivation {
  pname = "audit";
  version = "1.0.0";
  src = ./.; # Not used
  
  installPhase = ''
    mkdir -p $out
    cp ${readme} $out/README.md
    cp ${packageDiff} $out/package.diff
    cp ${prDiff} $out/pr.diff
    cp ${bip110ClientDiff} $out/bip110-client.diff
    cp ${brandingDiff} $out/branding.diff
  '';
}

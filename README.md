# bitcoin-knots-bip-110-nix

This is a [NixOS](https://nixos.org/) flake which provides GUI and non-GUI packages for the Bitcoin Knots BIP-110 activation client. See https://github.com/dathonohm/bitcoin/releases

## Packages

This flake contains three Nix packages:

- bitcoin-knots-bip-110 - This package provides a GUI
- bitcoind-knots-bip-110 - This package does NOT provide a GUI. 
- audit - A BASH script to help compare see the difference between this package and the original bitcoin-knots package. See below.

The package is a [copy](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/blockchains/bitcoin-knots/default.nix) of the bitcoin-knots package from the [Nixpkgs](https://github.com/NixOS/nixpkgs) repository; It was easier to copy and modify than to use an override.

## Usage

Firstly, *don't trust, verify*. Don't be lazy. Check my work *before* using this package. Namely, compare `pkgs/bitcoin-knots-bip-110/default.nix` to `pkgs/applications/blockchains/bitcoin-knots/default.nix` in Nixpkgs to audit my changes. To make it easier, I added a script you can use to run a diff:

```
nix run github:emmanuelrosa/bitcoin-knots-bip-110-nix#audit 
```

Yes, of course you should audit the audit script. See `pkgs/audit/default.nix`.

Once you're ready to use this package, add this flake to your NixOS flake-based configuration, and override your bitcoin-knots package:

```
 services.bitcoind.mainnet = {
   enable = true;
   package = bitcoin-knots-bip-110-nix.packages.x86_64-linux.bitcoind-knots-bip-110;
   ... 
 ```

 Then, you should be good to go.

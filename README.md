# bitcoin-knots-bip-110-nix

This is a [NixOS](https://nixos.org/) flake which provides GUI and non-GUI packages for the Bitcoin Knots BIP-110 activation client. See https://github.com/dathonohm/bitcoin/releases

- Contains a Nix package to build the Bitcoin Knots BIP-110 activation client, from its source code.
- The package performs automatic GPG verification; It refuses to build if certain maintainers have not signed the checksum file.

## Packages

This flake contains three Nix packages:

- ~bitcoin-knots-bip-110 - This package provides a GUI~ Removed because it doesn't build.
- bitcoind-knots-bip-110 - This package does NOT provide a GUI. 
- audit - A BASH script to compare the difference between this package and the original bitcoin-knots Nix package. See below.

The `bitcoin-knots-bip-110` package is a copy of the bitcoin-knots package from the [Nixpkgs](https://github.com/NixOS/nixpkgs) repository; Due to the package's complexity, it was easier to copy and modify than to use an override.

## Usage

Firstly, *don't trust, verify*. Don't be lazy. Check my work *before* using this package. Namely, compare `pkgs/bitcoin-knots-bip-110/default.nix` to `pkgs/applications/blockchains/bitcoin-knots/default.nix` in Nixpkgs to audit my changes. To make it easier, I added a script you can use to run a diff:

```
nix run github:emmanuelrosa/bitcoin-knots-bip-110-nix#audit 
```

Yes, of course you should audit the audit script, but it's simple and short. See `pkgs/audit/default.nix`.

Other things to consider:

- Is the Nixpkgs input the real Nixpkgs?
- Is the input for the BIP-110 client the correct one?
- Are the checksums and signatures coming from the correct place?

Once you're ready to use this package, add this flake to your NixOS flake-based configuration, and override your bitcoin-knots package:

```
 services.bitcoind.mainnet = {
   enable = true;
   package = bitcoin-knots-bip-110-nix.packages.x86_64-linux.bitcoind-knots-bip-110;
   ... 
 ```

 Then, you should be good to go.

 It's worth nothing that there's no Nix build cache, so when using this package you'll be compiling Bitcoin Knots from source. It will take a moment and is CPU intensive.

### A Quick test using regtest

One way to confirm you built the right thing is to run bitcoind in regtest mode and then look at the output of the `netinfo` RPC command:

```
nix shell github:emmanuelrosa/bitcoin-knots-bip-110-nix#bitcoin-knots-bip-110
export datadir=$(mktemp -d)
bitcoind -regtest -daemon -datadir=$datadir
bitcoin-cli -regtest -datadir=$datadir netinfo 3
echo $datadir/regtest/bitcoind.pid
kill [THE_PID_SHOWN_ABOVE]
```

You should see something like this:

```
Bitcoin Knots client v29.2.knots20251110+bip110-v0.1rc3 regtest - server 70016/Satoshi:29.2.0/Knots:20251110+bip110-v0.1rc3/UASF-BIP110:0.1/ - services nwl24
```

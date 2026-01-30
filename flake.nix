{
  description = "A Nix flake for the bitcoin-knots BIP-110 activation client";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
  };

  outputs = { self, nixpkgs }: let 
    forAllSystems = func: nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ] (system:
      func (
        import nixpkgs {
          inherit system;
        }
      )
      system
    );
  in {
    packages = forAllSystems (pkgs: system: {
      default = self.packages."${system}".bitcoin-knots-bip-110;

      bitcoind-knots-bip-110 = pkgs.callPackage ./pkgs/bitcoin-knots-bip-110 {
        withGui = false;
        inherit (pkgs.darwin) autoSignDarwinBinariesHook;
      };

      audit = pkgs.callPackage ./pkgs/audit { srcB = ./pkgs/bitcoin-knots-bip-110/default.nix; };
    });
  };
}

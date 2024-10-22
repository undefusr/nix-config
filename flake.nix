{
  description = "NixOS systems and tools by undefusr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zig.url = "github:mitchellh/zig-overlay";

    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty?ref=main";

    monolisa.url = "git+ssh://git@github.com/undefusr/monolisa?ref=main";
    monolisa.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, ... }:
    let
      overlays = [
        inputs.zig.overlays.default
      ];

      vmware_i3 = {
        nixos-modules = [
          ./hosts/vm-aarch64
          ./modules/nixos/user.nix
          ./modules/nixos/i3.nix
        ];
      };

      macbook = {
        darwin-modules = [
          ./hosts/darwin
        ];
      };

      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs overlays inputs;
      };
    in
    {
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        host-modules = vmware_i3.nixos-modules;
      };

      darwinConfigurations.macbook-pro-mx = mkSystem "macbook-pro-mx" {
        system = "aarch64-darwin";
        host-modules = macbook.darwin-modules;
        darwin = true;
      };
    };

}

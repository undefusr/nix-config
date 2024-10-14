{
  description = "NixOS systems and tools by undefusr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:
    let
      overlays = [
        inputs.zig.overlays.default
      ];
      mkSystem = import ./lib/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
    in
    {
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        user = "undefusr";
      };

      # darwinConfigurations.macbook-pro-m3 = mkSystem "macbook-pro-m3" {
      #   system = "aarch64-darwin";
      #   user = "undefusr";
      #   darwin = true;
      # };
    };

}

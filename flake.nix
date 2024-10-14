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
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, ... }:
    let
      username = "undefusr";
      userfullname = "Undefined User";
      useremail = "undefusr@proton.me";

      overlays = [
        inputs.zig.overlays.default
      ];

      vmware_i3 = {
        nixos-modules = [
          ./hosts/vm-aarch64
          ./modules/nixos/user.nix
          ./modules/nixos/i3.nix
          ./modules/nixos/kubernetes.nix
        ];
        home-modules = import ./home/core.nix;
      };

      mkSystem = import ./lib/mksystem.nix {
        inherit nixpkgs overlays inputs username userfullname useremail;
      };
    in
    {
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        host-modules = vmware_i3.nixos-modules;
        home-module = vmware_i3.home-modules;
      };

      # darwinConfigurations.macbook-pro-m3 = mkSystem "macbook-pro-m3" {
      #   system = "aarch64-darwin";
      #   modules = [];
      #   home-modules = [];
      #   darwin = true;
      # };
    };

}

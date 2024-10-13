{
  description = "NixOS systems and tools by undefusr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixpkgs-unstable-small, ghostty, ... }:
    let
      username = "undefusr";
    in
    {
      nixosConfigurations."vm-aarch64" = nixpkgs.lib.nixosSystem rec {
        system = "aarch64-linux";
        specialArgs = {
          inherit username;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        environment.systemPackages = [
          ghostty.packages.aarch64-linux.default
        ];
        modules = [
          ./hosts/vmware/default.nix
        ];
      };
    };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    keep-outputs = true;
    keep-derivations = true;
  };
}

# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, overlays, inputs }:

name:
{ system ? "aarch64-linux"
, user ? "undefusr"
, darwin ? false
}:

let
  # The config files for this system.
  hostConfig = ../hosts/${name}/.;
  # userHMConfig = ../users/${user}/home-manager.nix;

  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc rec {
  inherit system;
  specialArgs =
    {
      inherit inputs name system user darwin;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  modules = [
    { nixpkgs.overlays = overlays; }

    # Allow unfree packages.
    { nixpkgs.config.allowUnfree = true; }

    hostConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
      };
    }
  ];
}

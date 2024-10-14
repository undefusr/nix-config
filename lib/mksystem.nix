# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, overlays, inputs, username, userfullname, useremail }:

name:
{ system ? "aarch64-linux"
, darwin ? false
, host-modules ? [ ]
, home-module
}:
let
  # NixOS vs nix-darwin functionst
  systemFunc =
    if darwin then
      inputs.darwin.lib.darwinSystem
    else
      nixpkgs.lib.nixosSystem;

  home-manager =
    if darwin then
      inputs.home-manager.darwinModules.home-manager
    else
      inputs.home-manager.nixosModules.home-manager;

  specialArgs =
    {
      inherit username userfullname useremail;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
      };
    } // inputs;
in
systemFunc rec {
  inherit system specialArgs;
  modules = host-modules ++ [
    { nixpkgs.overlays = overlays; }

    { nixpkgs.config.allowUnfree = true; }

    home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${username} = home-module;
    }
  ];
}

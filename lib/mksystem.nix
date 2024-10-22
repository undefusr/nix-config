# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, overlays, inputs }:

name:
{ system ? "aarch64-linux"
, darwin ? false
, username ? "undefusr"
, useremail ? "undefusr@proton.me"
, userfullname ? "Undefined User"
, host-modules ? [ ]
}:
let
  # NixOS vs nix-darwin functionst
  systemFunc =
    if darwin then
      inputs.nix-darwin.lib.darwinSystem
    else
      nixpkgs.lib.nixosSystem;

  home-manager =
    if darwin then
      inputs.home-manager.darwinModules.home-manager
    else
      inputs.home-manager.nixosModules.home-manager;

  specialArgs =
    {
      inherit username userfullname useremail darwin inputs;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
      };
    };
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
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users.${username} = import ../users/${if darwin then "darwin" else "nixos" }/home.nix;
    }
  ];
}

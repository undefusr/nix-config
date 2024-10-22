{ pkgs, lib, username, darwin, ... }:
let
  homedir = if darwin then "/Users/${username}" else "/home/${username}";
in
{
  home = {
    username = username;
    homeDirectory = lib.mkForce homedir;


    # # Make cursor not tiny on HiDPI screens
    # pointerCursor = {
    #   name = "Vanilla-DMZ";
    #   package = pkgs.vanilla-dmz;
    #   size = 128;
    #   x11.enable = true;
    # };

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

}


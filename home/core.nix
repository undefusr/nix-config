{ pkgs, lib, username, ... }:
{
  # imports = [  ];

  home = {
    username = username;
    homeDirectory = lib.mkForce "/home/${username}";

    stateVersion = "24.05";

    # Make cursor not tiny on HiDPI screens
    pointerCursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 128;
      x11.enable = true;
    };
  };

  programs.home-manager.enable = true;
}

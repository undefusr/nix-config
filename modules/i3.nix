{ config, pkgs, ... }: {
  ####################################################################
  #
  #  NixOS's Configuration for I3 Window Manager
  #
  ####################################################################

  # i3 related options
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.displayManager.defaultSession = "none+i3";
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    xserver = {
      enable = true;
      dpi = 220;

      desktopManager = {
        xterm.enable = false;
        # wallpaper.mode = "scale";
      };
      displayManager = {
        lightdm.enable = true;
        sessionCommands = ''
          ${pkgs.xorg.xset}/bin/xset r rate 200 40
        '';
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          rofi # application launcher, the same as dmenu
          dunst # notification daemon
          i3blocks # status bar
          i3lock # default i3 screen locker
          xautolock # lock screen after some time
          i3status # provide information to i3bar
          i3-gaps # i3 with gaps
          picom # transparency and shadows
          feh # set wallpaper
          acpi # battery information
          arandr # screen layout manager
          dex # autostart applications
          xbindkeys # bind keys to commands
          # xorg.xbacklight # control screen brightness, the same as light
          xorg.xdpyinfo # get screen information
          scrot # minimal screen capture tool, used by i3 blur lock to take a screenshot
          sysstat # get system information
          alsa-utils # provides amixer/alsamixer/...

          xfce.thunar # xfce4's file manager
        ];
      };


      xkb = {
        layout = "us";
        variant = "dvorak";
      };
    };
  };

  # thunar file manager(part of xfce) related options
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
}

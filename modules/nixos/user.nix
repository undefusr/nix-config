{ config, pkgs, lib, user, ... }: {
  nix.settings.trusted-users = [ user ];

  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  programs.fish.enable = true;

  users.users."${user}" = {
    hashedPassword = "$6$Om3Qirooa1wUxt30$6S1ib5TOjEsBykvtL3wNFGazhjteaV9bx0wjfN2vs0taY39yeurPx5OLFxF.RadVCWx8PfFN0HIWvnqnKXfgt0";
    home = "/home/${user}";
    isNormalUser = true;
    extraGroups = [ user "cfssl" "kubernetes" "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };
}

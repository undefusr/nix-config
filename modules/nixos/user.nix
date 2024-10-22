{ pkgs, username, ... }: {
  nix.settings.trusted-users = [ username ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  users.users."${username}" = {
    hashedPassword = "$6$Om3Qirooa1wUxt30$6S1ib5TOjEsBykvtL3wNFGazhjteaV9bx0wjfN2vs0taY39yeurPx5OLFxF.RadVCWx8PfFN0HIWvnqnKXfgt0";
    home = "/home/${username}";
    isNormalUser = true;
    extraGroups = [ username "networkmanager" "wheel" "docker" ];
  };
}

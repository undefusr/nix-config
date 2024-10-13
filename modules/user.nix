{ username, pkgs, ... }: {
  nix.settings.trusted-users = [ username ];

  programs.fish.enable = true;

  users.users."${username}" = {
    hashedPassword = "$6$Om3Qirooa1wUxt30$6S1ib5TOjEsBykvtL3wNFGazhjteaV9bx0wjfN2vs0taY39yeurPx5OLFxF.RadVCWx8PfFN0HIWvnqnKXfgt0";
    home = "/home/${username}";
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "${username}" "cfssl" "kubernetes" "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    # packages = with pkgs; [ ] ++ pkgs;
  };
}


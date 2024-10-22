{ ... }: {
  xdg.enable = true;
  xdg.configFile = {
    "ghostty/config".text = builtins.readFile ./config;
  };
}


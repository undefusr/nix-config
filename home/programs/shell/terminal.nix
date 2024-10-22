{ pkgs, specialArgs, ... }:

let
  ghostty = specialArgs.inputs.ghostty;
in
{
  home.packages = with pkgs; [
    ghostty.packages.aarch64-linux.default
  ];


  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      background = "#ffffff";

      key_bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
      window.opacity = 0.95;
      window.dynamic_padding = true;
      window.padding = {
        x = 5;
        y = 5;
      };
      scrolling.history = 10000;
    };
  };
}

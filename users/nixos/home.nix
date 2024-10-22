{ pkgs, inputs, ... }: {
  imports = [
    ../../home/core.nix
    ../../home/programs/shell
    ../../home/programs/browsers.nix
  ];
}

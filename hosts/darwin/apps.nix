{ pkgs, ... }: {
  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    nushell
    htop
    fish
  ];
  environment.variables.EDITOR = "nvim";

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
    pkgs.fish
    pkgs.nushell # my custom shell
  ];

  # homebrew need to be installed manually, see https://brew.sh
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    taps = [
      "hashicorp/tap"
      "pulumi/tap"
    ];

    brews = [
      # `brew install`
      "ripgrep"
      "nnn"
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool
      "httpie" # http client
    ];

    # `brew install --cask`
    casks = [
      "firefox"
      "google-chrome"
      "visual-studio-code"
      "rio"
      "wezterm"
      "slack"
      "raycast"
      "aerospace"
      "font-jetbrains-mono-nerd-font"
      "git-credential-manager"
      "testcontainers-desktop"

      # Development
      "insomnia" # REST client
    ];
  };
}

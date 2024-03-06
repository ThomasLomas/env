{ lib, pkgs, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.tom = {
    name = "tom";
    home = "/Users/tom";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [ "nix-command" "flakes" ];
    };
  };

  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;  # default shell on catalina
  };

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    masApps = {
      Xcode = 497799835;
      Word = 462054704;
      Excel = 462058435;
      OneDrive = 823766827;
    };
    casks = [
      "docker"
      "discord"
      "google-chrome"
      "iterm2"
      "whatsapp"
      "zoom"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];
}

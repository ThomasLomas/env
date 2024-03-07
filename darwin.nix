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
  };

  programs.fish = {
    enable = true;

    shellInit = ''
      # As per Homebrew installation instructions.
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Workaround for the following issue:
      # - https://github.com/LnL7/nix-darwin/issues/122
      # - https://d12frosted.io/posts/2021-05-21-path-in-fish-with-nix-darwin.html
      for p in (string split " " $NIX_PROFILES); fish_add_path --prepend --move --path $p/bin; end
    '';
  };

  environment.shells = [ pkgs.fish ];

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      Xcode = 497799835;
      Word = 462054704;
      Excel = 462058435;
      OneDrive = 823766827;
      Bitwarden = 1352778147;
    };
    casks = [
      "docker"
      "discord"
      "google-chrome"
      "iterm2"
      "whatsapp"
      "zoom"
      "mullvadvpn"
      "vlc"
      "raycast"
      "rectangle"
      "alt-tab"
      "steam"
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];
}

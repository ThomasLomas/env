{ pkgs, nix-vscode-extensions, ... }:

{
  home.username = "tom";
  home.homeDirectory = "/Users/tom";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    duti
  ];

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;

    plugins = [
      # https://alexpearce.me/2021/07/managing-dotfiles-with-nix/#fish-shell:~:text=My%20final%20tweak%20was%20to%20include%20iTerm2%E2%80%99s%20shell%20integration%20as%20a%20fish%20plugin
      {
        name = "iterm2-shell-integration";
        src = ./config/iterm2/iterm2_shell_integration;
      }
      {
        name = "fish-completion-sync";
        src = pkgs.fetchFromGitHub {
          owner = "pfgray";
          repo = "fish-completion-sync";
          rev = "ba70b6457228af520751eab48430b1b995e3e0e2";
          sha256 = "sha256-JdOLsZZ1VFRv7zA2i/QEZ1eovOym/Wccn0SJyhiP9hI=";
        };
      }
    ];

    interactiveShellInit = ''
      # https://github.com/direnv/direnv/issues/68
      # https://stackoverflow.com/questions/51349012/stop-direnv-showing-all-environment-variables-on-load
      export DIRENV_LOG_FORMAT=

      iterm2_shell_integration

      # Easy printing with foreground and background colors
      function prompt_segment
        set -l bg $argv[1]
        set -l fg $argv[2]

        set_color -b $bg
        set_color $fg

        if [ -n "$argv[3]" ]
          echo -n -s $argv[3]
        end
      end

      function spacer
        prompt_segment normal normal " "
      end

      # Display status if previous command returned an error
      function show_status
        if [ $RETVAL -ne 0 ]
          prompt_segment normal red "!"
          spacer
        end
      end

      function show_pwd
        prompt_segment normal normal (prompt_pwd)
      end

      # TODO: show name of nix shell e.g. #prod-ops
      # The `$IN_NIX_SHELL` environment variable isn't set in a `nix shell` proper,
      # hence this workaround of checking the `$PATH`.
      #   https://discourse.nixos.org/t/in-nix-shell-env-variable-in-nix-shell-versus-nix-shell/15933
      #   https://github.com/NixOS/nix/issues/3862#issuecomment-707320241
      function is_nix_shell
        echo $PATH | grep -q /nix/store
      end

      function show_prompt
        if is_nix_shell
          prompt_segment normal normal "λ"
        else
          prompt_segment normal normal "\$"
        end
      end

      function fish_prompt
        set -g RETVAL $status
        show_pwd
        fish_git_prompt
        spacer
        show_status
        show_prompt
        spacer
      end

      set --global fish_greeting
    '';

    shellAbbrs = {
      "cat" = "bat";
      "up" = "nix run nix-darwin -- switch --flake ~/dotfiles/";
    };
  };

  programs.gh = {
    enable = true;
  };

  programs.git = {
    enable = true;

    userName = "Thomas Lomas";
    userEmail = "tlomas@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";

      push = {
        autoSetupRemote = true;
        default = "current";
      };

      # This adds a diff to the commit message template. This is a useful
      # reminder when writing commit messages, and also powers IDE
      # suggestions/completion.
      commit.verbose = true;
    };
  };

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      # [ref:color-theme]
      theme = "Visual Studio Dark+";
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with nix-vscode-extensions.extensions.aarch64-darwin.vscode-marketplace; [
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      jnoortheen.nix-ide
      ms-vscode-remote.remote-containers
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}

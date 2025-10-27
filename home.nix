{ config, pkgs, ... }:

let
  # Use the current working directory to find user-config.nix
  userConfigPath = ./user-config.nix;
  userConfig = 
    if builtins.pathExists userConfigPath
    then import userConfigPath
    else throw "user-config.nix not found. Please copy user-config.nix.template to user-config.nix and configure it.";
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.neofetch
    pkgs.gh
    pkgs.jq
    pkgs.awscli2
    pkgs.curl
    pkgs.wget

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/twelch/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    NVM_DIR = "$HOME/.nvm";
  };

  # Manual NVM installation using activation script
  home.activation.installNvm = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.nvm" ]; then
      echo "Installing NVM..."
      export PATH="${pkgs.curl}/bin:${pkgs.wget}/bin:$PATH"
      ${pkgs.curl}/bin/curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | ${pkgs.bash}/bin/bash
      echo "NVM installation completed"
    else
      echo "NVM already installed, skipping installation"
    fi
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    initExtra = ''
      # Load NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    '';
  };
  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = userConfig.git.userName;
      email = userConfig.git.userEmail;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      # Pure Prompt preset - mimics the Pure shell theme, limited nerd font symbol use with fallbacks
      "$schema" = "https://starship.rs/config-schema.json";
      
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
      right_format = "$all";

      username = {
        format = "[$user]($style) ";
        style_user = "yellow bold";
        style_root = "red bold";
        show_always = false;
      };

      hostname = {
        format = "[$hostname]($style) ";
        style = "green bold";
        ssh_only = true;
        disabled = false;
      };

      directory = {
        format = "[$path]($style)[$lock_symbol]($lock_style) ";
        style = "cyan bold";
        read_only = " 🔒";
        truncation_length = 4;
        truncate_to_repo = true;
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = "";
        style = "bold purple";
      };

      git_status = {
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        staged = "[+\${count}](green)";
        modified = "[!\${count}](yellow)";
        untracked = "[?\${count}](red)";
        conflicted = "[=\${count}](red)";
        deleted = "[-\${count}](red)";
        renamed = "[»\${count}](purple)";
        stashed = "[\$\${count}](cyan)";
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold red";
      };

      git_state = {
        format = "[$state( $progress_current of $progress_total)]($style) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
        min_time = 2000;
        show_milliseconds = false;
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      line_break = {
        disabled = false;
      };

      add_newline = true;
    };
  };

}

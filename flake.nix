{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pin to a commit to make copilot extension works
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/529e0a84346f34db86ea24203c0b2e975fefb4f2";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      mac-app-util,
      nix-darwin,
      nix-homebrew,
      nix-vscode-extensions,
      nixpkgs,
    }:
    let
      defaults = {
        hostname = "default-hostname";
        username = "default-username";
        fullName = "Default Name";
        email = "default@example.com";
        githubEmail = "your.github.default.email@example.com";
        architecture = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs
      };

      local = if builtins.pathExists ./local.nix then import ./local.nix else defaults;

      hostname = local.hostname;
      username = local.username;
      fullName = local.fullName;
      email = local.email;
      githubEmail = local.githubEmail;
      architecture = local.architecture;

      configuration =
        { pkgs, ... }:
        {
          nix.enable = false; # required when using Determinate Systems' Nix
          nix.settings = {
            experimental-features = "nix-command flakes";
            trusted-users = [ username ];
          };
          nix.settings.extra-substituters = [
            "https://devenv.cachix.org"
          ];
          nix.settings.extra-trusted-public-keys = [
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw"
          ];

          nixpkgs.hostPlatform = architecture;

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.activationScripts.postUserActivation.text = ''
            # activateSettings -u will reload the settings from the database and apply them to the current session,
            # so we do not need to logout and login again to make the changes take effect.
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          '';

          # Used for backwards compatibility. please read the changelog
          # before changing: `darwin-rebuild changelog`.
          system.stateVersion = 6;

          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToEscape = true;
          system.defaults = {
            NSGlobalDomain = {
              ApplePressAndHoldEnabled = false;
              "com.apple.swipescrolldirection" = false; # turn off natural scrolling
            };
            finder = {
              _FXShowPosixPathInTitle = true; # show full path in finder title
              AppleShowAllExtensions = true; # show all file extensions
              FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
              QuitMenuItem = true; # enable quit menu item
              ShowPathbar = true; # show path bar
              ShowStatusBar = true; # show status bar
            };
            loginwindow.LoginwindowText = "REWARD IF LOST: ${email}";
          };

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true;

          environment.systemPackages = [
            pkgs.devenv
            pkgs.fzf
            pkgs.neofetch
            pkgs.vim
          ];

          # Make sudo TouchID work in Tmux
          environment.etc = {
            "pam.d/sudo_local".text = ''
              # Managed by Nix Darwin
              auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
              auth       sufficient     pam_tid.so
            '';
          };

          imports = [
            ./homebrew.nix
          ];

          security.pam.services.sudo_local.touchIdAuth = true;

          nixpkgs.config.allowUnfree = true;

          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };

      homeconfig =
        { pkgs, config, ... }:
        {
          # this is internal compatibility configuration
          # for home-manager, don't change this!
          home.stateVersion = "23.05";
          # Let home-manager install and manage itself.
          programs.home-manager.enable = true;
          home.packages = with pkgs; [
            code-cursor
            home-manager
            htop
            nil
            nixd
            nixfmt-rfc-style
            nodejs_22
            python313
            uv
            tmux
          ];
          home.sessionVariables = {
            EDITOR = "vim";
          };

          home.file.".vimrc".source = ./vim_configuration;
          home.file.".config/zed/settings.json".source =
            config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/zed-config/settings.json";
          home.file."Library/Application Support/Code/User/settings.json".source =
            ./vscode-config/settings.json;

          programs.zsh = {
            enable = true;
            shellAliases = {
              switch = "darwin-rebuild switch --flake ~/.config/nix";
            };
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            plugins = [ ];
            oh-my-zsh.enable = true;
            oh-my-zsh.plugins = [
              "git"
              "sudo"
            ];
            oh-my-zsh.theme = "robbyrussell";
          };

          programs.direnv = {
            enable = true;
            enableZshIntegration = true;
          };

          programs.git = {
            enable = true;
            userName = local.fullName;
            userEmail = githubEmail;

            aliases = {
              "fixup" =
                "!git log -n 50 --pretty=format:\"%h %s\" --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
            };

            ignores = [
              ".DS_Store"
            ];
            extraConfig = {
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
            };
          };

          programs.gh = {
            enable = true;
            settings = {
              git_protocol = "https";
            };
          };

          programs.ghostty = {
            enable = true;
            enableZshIntegration = true;
            package = null; # use the homebrew version
            settings = {
              theme = "Dracula";
              font-size = 18;
              font-thicken = true;
              window-position-x = 0;
              window-position-y = 0;
            };
          };

          programs.tmux = {
            enable = true;
            clock24 = true;
            plugins = with pkgs.tmuxPlugins; [
              {
                plugin = dracula;
                extraConfig = ''
                  set -g @dracula-plugins "cpu-usage ram-usage battery time"

                  set -g @dracula-time-format "%A, %d %b %Y %I:%M%p %Z"

                  set -g @dracula-show-battery false
                  set -g @dracula-show-powerline true
                  set -g @dracula-refresh-rate 10

                  set -g @dracula-battery-label false
                  set -g @dracula-show-battery-status true
                  set -g @dracula-no-battery-label " "
                '';
              }
              {
                plugin = yank;
              }
            ];
            extraConfig = ''
              unbind C-b
              set -g prefix C-Space
              bind C-Space send-prefix

              set -g mouse on
              set -g base-index 1
              set -g pane-base-index 1
              set -g renumber-windows on

              set -g repeat-time 1000

              # Vim-style pane navigation
              bind h select-pane -L
              bind j select-pane -D
              bind k select-pane -U
              bind l select-pane -R

              # Vim-style window navigation
              bind -r C-h select-window -t :-
              bind -r C-l select-window -t :+

              # set vi-mode
              set-window-option -g mode-keys vi
              # keybindings
              bind-key -T copy-mode-vi v send-keys -X begin-selection
              bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
              bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

              # open panes in the same directory
              bind '"' split-window -v -c "#{pane_current_path}"
              bind % split-window -h -c "#{pane_current_path}"
            '';
          };
        };
    in
    {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            hostname
            username
            fullName
            email
            githubEmail
            architecture
            ;
        };

        modules = [
          ./modules/system.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = architecture == "aarch64-darwin";
              user = username;
              autoMigrate = true;
            };
          }
          configuration
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users."${username}" = homeconfig;
            home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
          }
        ];
      };
    };
}

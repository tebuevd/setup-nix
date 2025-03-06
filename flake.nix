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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      firefox-addons,
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

          imports = [
            ./homebrew.nix
          ];

          security.pam.services.sudo_local.touchIdAuth = true;

          nixpkgs.config.allowUnfree = true;

          nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
        };

      homeconfig =
        { pkgs, ... }:
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

          programs.vscode = {
            enable = true;
            profiles.default = {
              userSettings = {
                # This property will be used to generate settings.json:
                # https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
                "editor.formatOnSave" = true;
              };
              keybindings = [
                # See https://code.visualstudio.com/docs/getstarted/keybindings#_advanced-customization
                {
                  key = "shift+cmd+j";
                  command = "workbench.action.focusActiveEditorGroup";
                  when = "terminalFocus";
                }
              ];
              extensions = with pkgs.vscode-marketplace; [
                jnoortheen.nix-ide
                dracula-theme.theme-dracula
                vscodevim.vim
                github.copilot
                github.copilot-chat
              ];
            };
          };

          programs.ghostty = {
            enable = true;
            enableZshIntegration = true;
            package = null; # use the homebrew version
            settings = {
              theme = "catppuccin-macchiato";
              font-size = 18;
              font-thicken = true;
            };
          };

          programs.tmux = {
            enable = true;
            clock24 = true;
            plugins = with pkgs.tmuxPlugins; [
              {
                plugin = dracula;
                extraConfig = ''
                  set -g @dracula-show-battery false
                  set -g @dracula-show-powerline true
                  set -g @dracula-refresh-rate 10
                  set -g @dracula-plugins "cpu-usage ram-usage battery"
                  set -g @dracula-battery-label false
                  set -g @dracula-show-battery-status true
                  set -g @dracula-no-battery-label " "
                '';
              }
            ];
            extraConfig = ''
              set -g mouse on
              set -g base-index 1
              set -g pane-base-index 1

              set -g repeat-time 1000

              # Vim-style pane navigation
              bind h select-pane -L
              bind j select-pane -D
              bind k select-pane -U
              bind l select-pane -R

              # Vim-style window navigation
              bind -r C-h select-window -t :-
              bind -r C-l select-window -t :+
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

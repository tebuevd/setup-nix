{ nvf, pkgs, ... }:
let
  inherit (nvf.lib.nvim.binds) mkKeymap;
in
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        filetree.nvimTree.enable = true;

        keymaps = [
          {
            key = "<leader>y";
            mode = "v";
            action = "\"+y";
            silent = true;
            noremap = true;
          }
          {
            key = "<leader>yy";
            mode = "n";
            action = "\"+yy";
            silent = true;
            noremap = true;
          }
          (mkKeymap "n" "<leader>n"
            # lua
            ''
              function()
                if Snacks.config.picker and Snacks.config.picker.enabled then
                  Snacks.picker.notifications()
                else
                  Snacks.notifier.show_history()
                end
              end
            ''
            {
              desc = "Notification History";
              lua = true;
              unique = true;
            }
          )
          (mkKeymap "n" "<leader>yle"
            # lua
            ''
              function()
                require("myconfig.diagnostics").copy_diagnostics_under_cursor()
              end
            ''
            {
              desc = "Copy diagnostics under cursor to clipboard";
              lua = true;
              unique = true;
            }
          )
        ];
      };

      vim.visuals.nvim-web-devicons.enable = true;

      vim.utility = {
        oil-nvim = {
          enable = true;
          setupOpts = {
            keymaps = {
              "-" = {
                action = "actions.parent";
                mode = "n";
              };
            };
          };
        };

        snacks-nvim = {
          enable = true;
          setupOpts = {
            bigfile.enabled = true;
            input.enabled = true;
            notifier.enabled = true;
            picker.enabled = true;
          };
        };
      };

      vim.theme.enable = true;
      vim.theme.name = "dracula";
      vim.theme.style = "dark";

      vim.additionalRuntimePaths = [
        ../../nvim-config
      ];

      vim.assistant.copilot = {
        enable = true;
        mappings = {
          suggestion.accept = "<M-;>";
        };
        setupOpts.copilot_node_command = "${pkgs.nodejs_22.out}/bin/node";
      };

      vim.autocomplete.blink-cmp.enable = true;
      vim.autocomplete.blink-cmp.mappings.close = null;
      vim.autocomplete.blink-cmp.mappings.complete = null;
      vim.autocomplete.blink-cmp.sourcePlugins = {
        copilot = {
          enable = true;
          package = pkgs.vimPlugins.blink-copilot;
          module = "blink-copilot";
        };
      };
      vim.autocomplete.blink-cmp.setupOpts.sources.providers = {
        copilot = {
          name = "copilot";
          module = "blink-copilot";
          score_offset = 100;
          async = true;
        };
      };

      vim.autocomplete.blink-cmp.setupOpts.keymap = {
        preset = "none";

        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];

        # use Ctrl-e to toggle completion, since Ctrl-Space is used by tmux
        "<C-e>" = [
          "show"
          "hide"
        ];
      };
      vim.formatter.conform-nvim.enable = true;

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        html.enable = true;
        css.enable = true;

        lua.enable = true;

        tailwind.enable = true;
        tailwind.lsp.enable = true;

        nix.enable = true;
        nix.lsp.enable = true;
        nix.lsp.server = "nil";
        nix.format.enable = true;
        nix.format.package = pkgs.nixfmt-rfc-style;
        nix.format.type = "nixfmt";

        ts.enable = true;
        ts.lsp.enable = true;
        ts.format.enable = true;

        rust = {
          enable = true;
          lsp = {
            enable = true;
            opts = ''
              ['rust-analyzer'] = {
                cargo = {allFeature = true},
                checkOnSave = true,
                procMacro = {
                  enable = true,
                },
              },
            '';
          };

          format.enable = true;
        };

        python.enable = true;
        python.lsp.enable = true;
        python.lsp.server = "basedpyright";
        python.format.enable = true;
        python.format.type = "ruff";
      };

      vim.lsp.mappings.goToDefinition = "gd";
      vim.telescope = {
        enable = true;
        setupOpts.pickers.find_files = {
          hidden = true;
          find_command = [
            "${pkgs.ripgrep}/bin/rg"
            "--files"
            "--hidden"
            "--glob=!**/.git/*"
            "--sort=path"
          ];
        };
      };

      vim.extraPlugins = with pkgs.vimPlugins; {
        "vim-caddyfile" = {
          package = vim-caddyfile;
        };
      };

      vim.luaConfigRC.myconfig = ''
        require("myconfig")
      '';
    };
  };
}

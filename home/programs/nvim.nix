{ pkgs, ... }:

# NOTES:
# - To manually format, run `:lua vim.lsp.buf.format()`
#

{
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = true;
      vim.theme.name = "dracula";
      vim.theme.style = "dark";

      vim.autocomplete.blink-cmp.enable = true;
      vim.autocomplete.blink-cmp.mappings.close = null;
      vim.autocomplete.blink-cmp.mappings.complete = null;

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

      # adds format-on-save among other things
      vim.formatter.conform-nvim.enable = true;

      vim.languages = {
        enableLSP = true;
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;

        html.enable = true;
        css.enable = true;

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

        python.enable = true;
        python.lsp.enable = true;
        python.lsp.server = "basedpyright";
        python.format.enable = true;
        python.format.type = "ruff";
      };

      vim.lsp.mappings.goToDefinition = "gd";
      vim.telescope.enable = true;

      vim.luaConfigPost = ''
        vim.o.scrolloff = 5
      '';
    };
  };
}

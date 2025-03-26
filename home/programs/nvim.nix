{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = true;
      vim.theme.name = "dracula";
      vim.theme.style = "dark";

      vim.autocomplete.blink-cmp.enable = true;

      # adds format-on-save among other things
      vim.formatter.conform-nvim.enable = true;

      vim.languages.nix.enable = true;
      vim.languages.nix.lsp.enable = true;
      vim.languages.nix.lsp.server = "nil";
      vim.languages.nix.format.enable = true; # run :lua vim.lsp.buf.format()
      vim.languages.nix.format.package = pkgs.nixfmt-rfc-style;
      vim.languages.nix.format.type = "nixfmt";

      vim.languages.ts.enable = true;
      vim.languages.ts.lsp.enable = true;
      vim.languages.ts.format.enable = true;

      vim.languages.python.enable = true;
      vim.languages.python.lsp.enable = true;
      vim.languages.python.lsp.server = "basedpyright";
      vim.languages.python.format.enable = true;
      # vim.languages.python.format.package = pkgs.ruff;
      # vim.languages.python.format.type = "ruff";

      vim.lsp.mappings.goToDefinition = "gd";

      vim.telescope.enable = true;
    };
  };
}

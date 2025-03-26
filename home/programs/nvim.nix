{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;
    settings = {
      vim.theme.enable = true;
      vim.theme.name = "dracula";
      vim.theme.style = "dark";

      # adds format-on-save among other things
      vim.formatter.conform-nvim.enable = true;

      vim.languages.nix.enable = true;
      vim.languages.nix.lsp.enable = true;
      vim.languages.nix.lsp.server = "nil";
      vim.languages.nix.format.enable = true; # run :lua vim.lsp.buf.format()
      vim.languages.nix.format.package = pkgs.nixfmt-rfc-style;
      vim.languages.nix.format.type = "nixfmt";

      vim.telescope.enable = true;
    };
  };
}

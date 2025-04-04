{
  pkgs,
  bsky,
  ...
}:

{
  home.packages = with pkgs; [
    caddy
    claude-code
    delta
    fd
    home-manager
    htop
    neovim
    nil
    nixd
    nixfmt-rfc-style
    nodejs_22
    pnpm_10
    python312
    ripgrep
    ruff
    rustup
    tree-sitter
    tmux
    typescript
    uv
    bsky.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

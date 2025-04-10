{
  pkgs,
  bsky,
  ...
}:

{
  home.packages = with pkgs; [
    bsky.packages.${system}.default
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
    tmux
    tree-sitter
    typescript
    uv
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

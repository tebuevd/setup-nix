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
    home-manager
    htop
    nil
    nixd
    nixfmt-rfc-style
    nodejs_22
    pnpm_10
    python312
    ripgrep
    tmux
    typescript
    uv
    bsky.packages.${system}.default
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}

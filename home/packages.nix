{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    home-manager
    htop
    nil
    nixd
    nixfmt-rfc-style
    nodejs_22
    pnpm_10
    python313
    uv
    typescript
    tmux
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
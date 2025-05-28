{
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./keyboard.nix
    ./preferences.nix
    ./security.nix
    ./networking.nix
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.devenv
    pkgs.fzf
    pkgs.neofetch
    pkgs.vim
  ];

  nix.enable = false; # required when using Determinate Systems' Nix
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [
      "admin"
    ];
  };

  system.primaryUser = username;
  system.configurationRevision = null;
  nixpkgs.config.allowUnfree = true;
}

{
  pkgs,
  nix-vscode-extensions,
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
    trusted-users = [ username ];
  };

  system.configurationRevision = null;
  system.activationScripts.postUserActivation.text = ''
    # activateSettings -u will reload the settings from the database and apply them to the current session,
    # so we do not need to logout and login again to make the changes take effect.
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ];
}

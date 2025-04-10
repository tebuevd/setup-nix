_:

{
  imports = [
    ./packages.nix
    ./shell
    ./programs
    ./editors
  ];

  # This is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.05";

  # Let home-manager install and manage itself.
  programs.home-manager.enable = true;
}

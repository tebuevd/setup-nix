{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = null; # use the homebrew version
    settings = {
      theme = "Dracula";
      font-size = 18;
      font-thicken = true;
      window-position-x = 0;
      window-position-y = 0;
    };
  };
}
_:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/.config/nix";
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [ ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "npm"
        "sudo"
      ];
      theme = "robbyrussell";
    };
  };
}

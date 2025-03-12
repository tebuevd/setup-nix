{ ... }:

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
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [
      "git"
      "sudo"
    ];
    oh-my-zsh.theme = "robbyrussell";
  };
}
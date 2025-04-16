{
  fullName,
  githubEmail,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      package = pkgs.delta;
      options = {
        side-by-side = true;
        tabs = 2;
      };
    };
    userName = fullName;
    userEmail = githubEmail;

    aliases = {
      "fixup" =
        "!git log -n 50 --pretty=format:\"%h %s\" --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
    };

    ignores = [
      ".DS_Store"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
    };
  };
}

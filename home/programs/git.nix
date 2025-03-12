{ fullName, githubEmail, ... }:

{
  programs.git = {
    enable = true;
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
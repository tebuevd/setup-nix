_: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";

    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    brews = [
      "borders"
      "cowsay"
      "mactop"
    ];
    casks = [
      "1password"
      "aerospace"
      "bruno"
      "cryptomator"
      "cursor"
      "cyberduck"
      "firefox"
      "ghostty"
      "google-chrome"
      "granola"
      "imazing"
      "leader-key"
      "ollama"
      "omnidisksweeper"
      "orion"
      "outline-manager"
      "raycast"
      "reflect"
      "screen-studio"
      "secretive"
      "shottr"
      "signal"
      "stats"
      "steam"
      "superhuman"
      # "tableplus" -- i'm using an older version due to having an old license
      "tailscale"
      "visual-studio-code"
      "vlc"
      "zed"
      "zoom"
    ];

    # mas cli is currently broken on macOS 15.4 which results in these app being reinstalled on every rebuild
    # therefore i'm disabling this for now

    # masApps = {
    #   "1Password for Safari" = 1569813296;
    #   "Velja" = 1607635845;
    #   "Voice Type:Real Time Dictation" = 6736525125;
    # };
  };
}

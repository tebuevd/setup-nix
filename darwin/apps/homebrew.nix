{ ... }:
{
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
      "aerospace"
      "1password"
      "bruno"
      "cryptomator"
      "cursor"
      "cyberduck"
      "firefox"
      "ghostty"
      "granola"
      "google-chrome"
      "imazing"
      "leader-key"
      "ollama"
      "omnidisksweeper"
      "orion"
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

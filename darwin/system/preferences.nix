{ email, ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      "com.apple.swipescrolldirection" = false; # turn off natural scrolling
    };
    finder = {
      _FXShowPosixPathInTitle = true; # show full path in finder title
      AppleShowAllExtensions = true; # show all file extensions
      FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
      QuitMenuItem = true; # enable quit menu item
      ShowPathbar = true; # show path bar
      ShowStatusBar = true; # show status bar
    };
    loginwindow.LoginwindowText = "REWARD IF LOST: ${email}";
  };

  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 6;
}
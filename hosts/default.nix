{ lib, ... }:

let
  defaults = {
    hostname = "default-hostname";
    username = "default-username";
    fullName = "Default Name";
    email = "default@example.com";
    githubEmail = "your.github.default.email@example.com";
    architecture = "aarch64-darwin"; # or "x86_64-darwin" for Intel Macs
  };

  local = if builtins.pathExists ../local.nix then import ../local.nix else defaults;
in
{
  _module.args = {
    hostname = local.hostname;
    username = local.username;
    fullName = local.fullName;
    email = local.email;
    githubEmail = local.githubEmail;
    architecture = local.architecture;
  };
}

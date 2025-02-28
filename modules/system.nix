{ hostname, username, ... }:

{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}" = {
    home = "/Users/${username}";
    name = "${username}";
    description = "${username}";
  };
}

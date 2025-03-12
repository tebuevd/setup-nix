{ architecture, ... }:

{
  imports = [
    ./system
    ./apps
  ];

  # Set platform architecture
  nixpkgs.hostPlatform = architecture;
}
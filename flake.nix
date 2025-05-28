{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bsky.url = "github:tebuevd/bsky";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      bsky,
      home-manager,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      nvf,
    }:
    let
      # Import host configuration
      host = import ./hosts { inherit (nixpkgs) lib; };
      specialArgs = host._module.args;
      hostname = specialArgs.hostname;
      username = specialArgs.username;
      architecture = specialArgs.architecture;
    in
    {
      darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules = [
          ./hosts/default.nix
          ./darwin

          # Homebrew configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = architecture == "aarch64-darwin";
              user = username;
              autoMigrate = true;
            };
          }

          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users."${username}" = import ./home;
            home-manager.sharedModules = [
              nvf.homeManagerModules.default
            ];
            home-manager.extraSpecialArgs = specialArgs // {
              inherit bsky nvf;
            };
          }
        ];
      };
    };
}

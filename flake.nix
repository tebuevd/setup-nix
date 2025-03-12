{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pin to a commit to make copilot extension works
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/529e0a84346f34db86ea24203c0b2e975fefb4f2";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      mac-app-util,
      nix-darwin,
      nix-homebrew,
      nix-vscode-extensions,
      nixpkgs,
    }:
    let
      # Import host configuration
      host = import ./hosts/default.nix { inherit (nixpkgs) lib; };
      specialArgs = host._module.args // { inherit nix-vscode-extensions; };
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
          
          # Mac App Util
          mac-app-util.darwinModules.default
          
          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users."${username}" = import ./home;
            home-manager.sharedModules = [ 
              mac-app-util.homeManagerModules.default 
            ];
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
    };
}
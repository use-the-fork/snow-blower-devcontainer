{                                                                                                    
  description = "Snowblower devcontainer";                                                     
                                                                                                     
  inputs = {        
    # global, so they can be `.follow`ed
    systems.url = "github:nix-systems/default-linux";
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Powered by
    flake-utils.url = "github:numtide/flake-utils";

  };                                                                                                 

  outputs = inputs@{self, nixpkgs, flake-utils, home-manager, ...}:
    flake-utils.lib.eachDefaultSystem (system: 
    let 
        username = "USER";
        pkgs = import nixpkgs { inherit system; };
    in {
        legacyPackages = {
            homeConfigurations = {
                "${username}" = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [ 
                      {
                        home = {
                          username = "${username}";
                          homeDirectory = "/home/${username}";
                        };
                      }
                      ./home 
                    ];
                };
            };
        };
    });
}
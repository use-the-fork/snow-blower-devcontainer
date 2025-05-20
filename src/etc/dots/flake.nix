{                                                                                                    
  description = "Starship prompt configuration";                                                     
                                                                                                     
  inputs = {                                                                                         
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };                                      
  };                                                                                                 


  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = import ./shell/starship.nix { 
          inherit pkgs; 
          lib = pkgs.lib;
        };
      };
    };                                                                                             
}   


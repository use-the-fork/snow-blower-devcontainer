{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations.code = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home = {
            username = "code";
            homeDirectory = "/home/code";
            stateVersion = "23.11";
            
            packages = with nixpkgs.legacyPackages.x86_64-linux; [
              ripgrep
              fd
              jq
              yq
              bat
              exa
              fzf
              htop
              tmux
            ];
            
            file = {
              ".config/nixpkgs/config.nix".text = ''
                { allowUnfree = true; }
              '';
            };
          };
          
          programs = {
            home-manager.enable = true;
            
            git = {
              enable = true;
              userName = "Developer";
              userEmail = "dev@example.com";
              extraConfig = {
                init.defaultBranch = "main";
                pull.rebase = true;
                push.autoSetupRemote = true;
              };
            };
            
            bash = {
              enable = true;
              shellAliases = {
                ll = "ls -la";
                ".." = "cd ..";
              };
            };
            
            direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
          };
        }
      ];
    };
  };
}

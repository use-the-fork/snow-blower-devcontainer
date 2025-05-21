{ config, pkgs, ... }: {

  imports = [ 
      ./shell
    ];

  home = {

        enableNixpkgsReleaseCheck = false;
        username = "code";
        homeDirectory = "/home/code";
        stateVersion = "24.05";

        sessionVariables = { };
        # programs.home-manager.enable = true;

      packages = [
          pkgs.just
      ];
        
  };
}
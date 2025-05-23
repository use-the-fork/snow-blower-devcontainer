{ config, pkgs, ... }: {

  imports = [ 
      ./shell
      ./packages.nix
    ];

  config = {
    programs.home-manager.enable = true;
    home = {
            enableNixpkgsReleaseCheck = false;
            stateVersion = "24.05";
            sessionVariables = { };
      };
  };
}
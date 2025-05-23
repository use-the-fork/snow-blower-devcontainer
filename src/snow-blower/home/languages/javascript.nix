{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./utils.nix {inherit lib;}) mkLanguage;
  inherit (lib) mkOption mkEnableOption types;
  inherit (lib) mkIf;

  javascript = config.modules.languages.javascript;
in {
  options.modules.languages.javascript = mkLanguage {
    name = "Javascript";
    package = pkgs.nodejs_24;
    settings = {
      yarn = {
        enable = mkEnableOption "Whether to enable Yarn package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.yarn-berry;
          description = "Yarn package to use";
        };
      };

      pnpm = {
        enable = mkEnableOption "Whether to enable pnpm package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.pnpm;
          description = "pnpm package to use";
        };
      };

      bun = {
        enable = mkEnableOption "Whether to enable bun package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.bun;
          description = "bun package to use";
        };
      };
    };
  };

  config = mkIf javascript.enable {
    home.packages = with pkgs;
      [
        # Always include the configured Node.js version
        javascript.package
      ]
      # Add yarn if enabled
      ++ lib.optional javascript.settings.yarn.enable javascript.settings.yarn.package
      # Add pnpm if enabled
      ++ lib.optional javascript.settings.pnpm.enable javascript.settings.pnpm.package
      # Add bun if enabled
      ++ lib.optional javascript.settings.bun.enable javascript.settings.bun.package;

    # Node.js environment setup
    home.sessionVariables = {
      # Set NODE_PATH to include global modules
      NODE_PATH = "$HOME/.node_modules/lib/node_modules:$NODE_PATH";
    };

    # Create local npm directory for global installs without sudo
    home.file.".npmrc" = {
      enable = true;
      text = ''
        prefix=~/.node_modules
      '';
    };

    # Ensure the node_modules directory exists
    home.activation.createNodeModulesDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.node_modules/bin
    '';

    # Add node_modules/bin to PATH
    home.sessionPath = [
      "$HOME/.node_modules/bin"
    ];
  };
}

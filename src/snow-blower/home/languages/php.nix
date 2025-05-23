{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./utils.nix {inherit lib;}) mkLanguage;
  inherit (lib) mkOption mkEnableOption mkIf types attrValues getAttrs;

  cfg = config.modules.languages.php;

  filterDefaultExtensions = ext: builtins.length (builtins.filter (inner: inner == ext.extensionName) cfg.settings.disableExtensions) == 0;

  configurePackage = package:
    package.buildEnv {
      extensions = {
        all,
        enabled,
      }:
        with all; (builtins.filter filterDefaultExtensions (enabled ++ attrValues (getAttrs cfg.settings.extensions package.extensions)));
      extraConfig = cfg.settings.ini;
    };
in {
  options.modules.languages.php = mkLanguage {
    name = "PHP";
    package = pkgs.php83;
    settings = {
      composer = {
        enable = mkEnableOption "Whether to enable Composer package manager";
        package = mkOption {
          type = types.package;
          default = pkgs.php83Packages.composer;
          description = "Composer package to use";
        };
      };

      ini = mkOption {
        type = types.nullOr types.lines;
        default = "";
        description = ''
          PHP.ini directives. Refer to the "List of php.ini directives" of PHP's
        '';
      };

      extensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          PHP extensions to enable.
        '';
      };

      disableExtensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          PHP extensions to disable.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; let
      finalPackage = configurePackage cfg.package;
    in
      [
        # Always include the configured PHP version
        finalPackage
      ]
      # Add composer if enabled
      ++ lib.optional cfg.settings.composer.enable cfg.settings.composer.package;

    # Create composer directory
    home.activation.createComposerDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.composer/vendor/bin
    '';

    # Add composer bin to PATH
    home.sessionPath = [
      "$HOME/.composer/vendor/bin"
    ];

    # PHP configuration
    home.file.".config/php/php.ini" = {
      enable = true;
      text = cfg.settings.ini;
    };
  };
}

{ pkgs, ... }:
{
  # User-specific packages
  home.packages = [
    pkgs.any-nix-shell
    pkgs.git
    pkgs.direnv

    # pkgs.fd
    # pkgs.fzf
    # pkgs.gawk
    # pkgs.gh
    # pkgs.gnused
    # pkgs.jq
    # pkgs.less
    # pkgs.pure-prompt
    # pkgs.ripgrep
  ];
}
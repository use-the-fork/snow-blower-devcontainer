{pkgs, ...}: {
  # User-specific packages
  home.packages = with pkgs; [
    any-nix-shell
    fzf
    git
    direnv
    ripgrep
    jq
    rsync
    fd

    # pkgs.gawk
    # pkgs.gh
    # pkgs.gnused
    # pkgs.less
    # pkgs.pure-prompt
    # pkgs.ripgrep
  ];
}

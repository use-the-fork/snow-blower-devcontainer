{
  config = {
    programs.dircolors = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        OTHER_WRITABLE = "30;46";
        ".sh" = "01;32";
        ".csh" = "01;32";
      };
    };
  };
}

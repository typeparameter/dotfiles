{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-style = "Medium";
      font-feature = "-calt";
      font-size = 16;

      window-width = 120;
      window-height = 40;

      theme = "light:Apple System Colors Light,dark:Monokai Pro";
    };
  };
}

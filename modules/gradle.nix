{ config, lib, ... }:

{
  programs.gradle = {
    enable = true;
    home = lib.removePrefix "${config.home.homeDirectory}/" "${config.xdg.dataHome}/gradle";
  };
}

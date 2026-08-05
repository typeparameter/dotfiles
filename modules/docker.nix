{ config, pkgs, ... }:

{
  home.packages = [ pkgs.docker-client ];

  home.sessionVariables = {
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
  };
}

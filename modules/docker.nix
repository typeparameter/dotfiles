{ config, pkgs, ... }:

{
  home.packages = [ pkgs.docker-client ];

  # Set DOCKER_CONFIG directly instead of enabling programs.docker-cli so
  # Docker can manage mutable CLI state such as logins and contexts.
  home.sessionVariables = {
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
  };
}

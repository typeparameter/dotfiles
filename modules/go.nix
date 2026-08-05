{ config, pkgs, ... }:

{
  # Install through mise as needed
  programs.go.enable = false;

  home.sessionVariables = {
    GOBIN = config.xdg.binHome;
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    GOPATH = "${config.xdg.dataHome}/go";
  };
}

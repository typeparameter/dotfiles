{ config, ... }:

{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";

    # Install Claude Code outside of Nixpkgs for more frequent updates
    package = null;
  };
}

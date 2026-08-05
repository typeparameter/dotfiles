{ config, ... }:

{
  programs.npm = {
    enable = true;

    # Install through mise as needed
    package = null;

    settings = {
      cache = "${config.xdg.cacheHome}/npm";
      prefix = "${config.xdg.dataHome}/npm";
      logs-dir = "${config.xdg.stateHome}/npm/logs";
    };
  };

  home.sessionVariables = {
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
  };
}

{ config, lib, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      path = "${config.xdg.stateHome}/zsh/history";
      size = 50000;
      save = 10000;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;

      plugins = [ "vi-mode" ];

      extraConfig = ''
        HIST_STAMPS='yyyy-mm-dd'

        zstyle ':omz:lib:*' aliases no
        zstyle ':omz:lib:history' aliases yes
      '';
    };

    shellGlobalAliases = {
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
      "......" = "../../../../..";
    };
  };
}

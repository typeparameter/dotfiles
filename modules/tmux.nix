{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    keyMode = "vi";
    shortcut = "a";

    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      logging
      pain-control
      {
        plugin = open;
        extraConfig = ''
          set -g @open-S 'https://www.duckduckgo.com/?q='
        '';
      }
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
        '';
      }
    ];

    extraConfig = ''
      bind-key -T copy-mode-vi v send -X begin-selection

      set -g status-right ""
    '';
  };
}

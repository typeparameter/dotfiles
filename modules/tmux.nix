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
      {
        plugin = better-mouse-mode;
        extraConfig = ''
          set -g @scroll-without-changing-pane 'on'
          set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
        '';
      }
    ];

    extraConfig = ''
      # Prevent new tmux login shells from inheriting Determinate Nix's
      # initialization guard so Nix can restore PATH after
      # path_helper runs on macOS
      set-environment -gu __ETC_PROFILE_NIX_SOURCED

      # Add vim visual selection keybind
      bind-key -T copy-mode-vi v send -X begin-selection

      # Clean up status bar
      set -g status-right ""
    '';
  };
}

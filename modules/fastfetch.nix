{
  programs.fastfetch = {
    enable = true;

    settings = {
      display.size.ndigits = 0;
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        {
          type = "display";
          compactType = "original-with-refresh-rate";
        }
        "de"
        "wm"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        {
          type = "memory";
          format = "{} / {}";
        }
        {
          type = "disk";
          format = "{} / {}";
        }
        "localip"
        "break"
        "colors"
      ];
    };
  };

  home.shellAliases = {
    ff = "fastfetch";
  };
}

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    extraConfig = ''
      colorscheme habamax
      set number
      set hlsearch

      set tabstop=4
      set shiftwidth=4

      set expandtab
      set smarttab
    '';
  };
}

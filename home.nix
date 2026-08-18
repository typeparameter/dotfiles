{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./local.nix
    ./modules/codex.nix
    ./modules/darwin.nix
    ./modules/docker.nix
    ./modules/fastfetch.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/go.nix
    ./modules/gradle.nix
    ./modules/neovim.nix
    ./modules/node.nix
    ./modules/python.nix
    ./modules/ruby.nix
    ./modules/rust.nix
    ./modules/starship.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];

  home.stateVersion = "26.05";
  home.preferXdgDirectories = true;
  xdg.enable = true;
  xdg.localBinInPath = true;

  home.packages =
    with pkgs;
    [
      awscli2
      diffutils
      gnugrep
      jq
      pnpm
    ]
    ++ lib.optionals stdenv.isLinux [
      trash-cli
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.trash
    ];

  home.sessionVariables = {
    PAGER = "less";
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  programs = {
    home-manager = {
      enable = true;
    };

    eza = {
      enable = true;
      git = true;
    };

    less = {
      enable = true;
      options = {
        RAW-CONTROL-CHARS = true;
      };
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    nh = {
      enable = true;

      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 2 --keep-since 5d";
      };
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  home.shellAliases = {
    "ls" = "eza";
    "tree" = "eza --tree";
    "l" = "eza -la";
    "ll" = "eza -l";

    "diff" = "diff --color=auto";
    "grep" = "grep --color=auto";

    "cp" = "cp -iv";
    "mv" = "mv -iv";
    "rm" = "rm -v";
    "mkdir" = "mkdir -pv";
  };
}

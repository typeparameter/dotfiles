{
  programs.git = {
    enable = true;

    ignores = [
      ".DS_Store"
    ];

    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      pretty.dag-node = "%C(yellow)%h%C(reset) %C(cyan)%an%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s";

      alias = {
        "co" = "checkout";
        "ls" = "branch -vv";
        "nb" = "checkout -b";
        "db" = "branch -d";
        "dag" = "log --graph --date-order --format=dag-node";
        "recommit" = "!d=$(date) && GIT_COMMITTER_DATE=\"$d\" git commit --amend --date=\"$d\"";
      };
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
      };
    };
  };
}

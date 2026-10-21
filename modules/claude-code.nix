{
  programs.claude-code = {
    enable = true;

    # Install Claude Code outside of Nixpkgs for more frequent updates
    package = null;
  };
}

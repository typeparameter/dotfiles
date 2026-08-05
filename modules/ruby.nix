{ config, ... }:

let
  rcFile = "${config.xdg.configHome}/irb/irbrc";
in
{
  home.sessionVariables = {
    BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
    BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
    BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";

    GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";

    IRBRC = rcFile;
  };

  home.file."${rcFile}".text = ''
    require "fileutils"

    IRB.conf[:HISTORY_FILE] ||= File.join(ENV["XDG_STATE_HOME"], "irb", "history")
    IRB.conf[:SAVE_HISTORY] ||= 1000

    FileUtils.mkdir_p(File.dirname(IRB.conf[:HISTORY_FILE]))
  '';
}

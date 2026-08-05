{ config, ... }:

let
  startupFile = "${config.xdg.configHome}/python/.pythonrc";
in
{
  home.sessionVariables = {
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    PYTHONSTARTUP = startupFile;
  };

  home.file."${startupFile}".text = ''
    import sys

    if sys.version_info < (3, 13):
      import atexit
      import os
      import readline

      histfile = os.environ['PYTHON_HISTORY']

      try:
        readline.read_history_file(histfile)
        init_len = readline.get_current_history_length()
        append = hasattr(readline, 'append_history_file')
      except (IOError, OSError):
        init_len = 0
        append = False

      def save(prev_len, append):
        new_len = readline.get_current_history_length()
        readline.set_history_length(1000)

        try:
          if append:
            readline.append_history_file(new_len - prev_len, histfile)
          else:
            readline.write_history_file(histfile)
        except (IOError, OSError):
          pass

      atexit.register(save, init_len, append)
  '';
}

{
  files.".config/tmux/tmux.conf".text = ''
    run-shell "find ~/.config/tmux/conf.d -print0 | xargs -0 -n1 tmux source-file"
  '';
}

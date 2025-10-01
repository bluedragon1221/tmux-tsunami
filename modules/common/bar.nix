{tsunamiLib, ...}: let
  inherit (tsunamiLib) scriptPath;
in {
  tsunami = {
    scripts = {
      "battery" = ''
        energy_now=$(cat /sys/class/power_supply/BAT0/energy_now)
        energy_full=$(cat /sys/class/power_supply/BAT0/energy_full)
        percentage=$((energy_now * 100 / energy_full))
        printf "%.0f%%" "$percentage"
      '';

      "bar" = ''
        bg="#1e1e2e"

        tmux set -g status on

        tmux set -g status-position bottom
        tmux set -g status-justify absolute-centre
        tmux set -g status-bg "$bg"

        tmux set -g status-left-style fg=green,bold
        tmux set -g status-left " #{client_session}"

        tmux set -g window-status-style fg=color243
        tmux set -g window-status-format " #I "
        tmux set -g window-status-current-style fg=color12,bold
        tmux set -g window-status-current-format " #I "
        tmux set -g window-status-separator ""

        tmux set -g status-right "#[fg=color243]%l:%M  #[fg=red]#(${scriptPath "battery"}) "

        bg_dark="#181825"

        ## pane borders
        tmux set -g pane-border-style fg=$bg_dark,bg=$bg_dark
        tmux set -g pane-active-border-style fg=$bg_dark,bg=$bg_dark

        ## pane backgrounds
        # Set the foreground/background color for the active window
        tmux set -g window-active-style bg=$bg

        # Set the foreground/background color for all other windows
        tmux set -g window-style bg=$bg_dark
      '';
    };

    confs."bar" = ''
      run-shell ${scriptPath "bar"}
    '';
  };
}

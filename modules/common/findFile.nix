{
  pkgs,
  config,
  lib,
  tsunamiLib,
  ...
}: let
  inherit (tsunamiLib) scriptPath filePath;
  cfg = config.findFile;
in {
  options = {
    tsunami.findFile = {
      enable = lib.mkEnableOption "find file";
    };
  };

  config = lib.mkIf cfg.enable {
    tsunami.keys.leader = [
      {
        name = "Find File";
        key = "C-f";
        exec = ''run-shell "${scriptPath "minibuffer"} -d '#{?@default-path,#{@default-path},#{pane_current_path}}' '${scriptPath "find-file"}'"'';
      }
    ];
  };
  tsunami.scripts = {
    "minibuffer" = ''
      window_height="$(tmux display -p '#{window_height}')"
      tmux display-popup -EB \
        -w 100% -h 16 \
        -x 0 -y "$(($window_height + 1))" \
        "$@"
    '';

    "find-file" = ''${pkgs.broot}/bin/broot --conf ${filePath "broot_find_file.toml"}'';
  };

  tsunami.files."broot_find_file.toml" = (pkgs.formats.toml {}).generate "broot_find_file.toml" {
    imports = ["~/.config/broot/conf.toml"];
    quit_on_last_cancel = true;
    verbs = [
      {
        invocation = "tmux-split";
        external = ["bash" "-c" ''${scriptPath "split"} -c "#{?@default-path,#{@default-path},#{pane_current_path}}" "${lib.getExe cfg.editor} '{file}'"''];
        key = "ctrl-s";
        apply_to = "file";
        leave_broot = true;
      }
      {
        invocation = "tmux-window";
        external = ["tmux" "new-window" "-c" "#{?@default-path,#{@default-path},#{pane_current_path}}" "${lib.getExe cfg.editor} '{file}'"];
        key = "ctrl-w";
        apply_to = "file";
        leave_broot = true;
      }
      {
        key = "enter";
        cmd = ":tmux-window";
      }
    ];
  };
}

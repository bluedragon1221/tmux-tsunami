{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.tsunami.lazygit;
in {
  options = {
    tsunami.lazygit = {
      enable = lib.mkEnableOption "lazygit popup window";
    };
  };

  config = lib.mkIf cfg.enable {
    tsunami.keys.leader = [
      {
        name = "Lazygit";
        key = "C-g";
        exec = "display-popup -E -w 80% -h 80% -x C -y C -d '#{?@default-path,#{@default-path},#{pane_current_path}}' ${lib.getExe pkgs.lazygit}";
      }
    ];
  };
}

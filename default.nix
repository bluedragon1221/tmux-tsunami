{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
in {
  imports = [
    ./config.nix
  ];

  options = {
    tsunami = {
      enable = mkEnableOption "tsunami tmux distro";
      editor = mkOption {
        type = lib.types.package;
      };
    };
  };
}

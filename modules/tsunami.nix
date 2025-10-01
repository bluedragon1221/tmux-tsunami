{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  cfg = config.tsunami;
in {
  imports = lib.filesystem.listFilesRecursive ./common;

  options = {
    tsunami = {
      enable = mkEnableOption "tsunami tmux distro";
      editor = mkOption {
        type = lib.types.package;
      };

      scripts = mkOption {
        type = lib.types.attrsOf (lib.types.str);
      };

      files = mkOption {
        type = lib.types.attrsOf (lib.types.str);
      };

      confs = mkOption {
        type = lib.types.attrsOf (lib.types.str);
      };
    };
  };

  config = {
    files =
      (
        cfg.scripts
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/scripts/${name}.sh";
          value = {
            text = value;
            executable = true;
          };
        })
        |> lib.attrValues
        |> builtins.listToAttrs
      )
      // (
        cfg.files
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/files/${name}";
          value.text = value;
        })
        |> lib.attrValues
        |> builtins.listToAttrs
      )
      // (
        cfg.confs
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/conf.d/${name}.conf";
          value.text = value;
        })
        |> lib.attrValues
        |> builtins.listToAttrs
      );

    packages = [pkgs.tmux];
  };
}

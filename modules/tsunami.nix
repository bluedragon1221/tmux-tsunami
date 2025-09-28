{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
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
        types = lib.types.attrsOf (lib.types.str);
      };
    };
  };

  config = {
    files =
      (
        config.tsunami.scripts
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/scripts/${name}.sh";
          value = {
            text = value;
            executable = true;
          };
        })
        |> builtins.listToAttrs
      )
      // (
        config.tsunami.files
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/files/${name}";
          value.text = value;
        })
        |> builtins.listToAttrs
      )
      // (
        config.tsunami.confs
        |> builtins.mapAttrs (name: value: {
          name = ".config/tmux/conf.d/${name}.conf";
          value.text = value;
        })
        |> builtins.listToAttrs
      );

    packages = [pkgs.tmux];
  };
}

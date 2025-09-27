{
  lib,
  config,
  tsunamiLib,
  ...
}: let
  inherit (tsunamiLib) scriptPath;
  inherit (lib.strings) escapeShellArg;
  cfg = config.tsunami.keys;
in {
  options = let
    tmuxKey = lib.types.strMatching "^(?:[CMS]-)*(?:[A-Za-z0-9]|Enter|Escape|Tab|Up|Down|Left|Right|Home|End|Insert|Delete|PageUp|PageDown|PgUp|PgDn|F[1-9][0-2]?|BSpace|BTab|KP[0-9]|KPEnter)$";
  in {
    tsunami.keys = {
      leader = lib.mkOption {
        type = with lib.types;
          listOf (submodule {
            name = mkOption {type = str;};
            key = mkOption {type = tmuxKey;};
            exec = mkOption {type = str;};
          });
      };

      global = lib.mkOption {
        type = with lib.types;
          listOf (submodule {
            key = mkOption {type = tmuxKey;};
            exec = mkOption {type = str;};
          });
      };
    };
  };

  config = {
    tsunami.scripts."leader-menu" = ''
      ${scriptPath "menu"} ${cfg.leader |> builtins.map (f: ''"${escapeShellArg f.name}" ${f.key} "${escapeShellArg f.exec}"'') |> lib.concatStringsSep " "}
    '';
    tsunami.keys.global = [
      {
        key = "C-x";
        exec = "run-shell ${scriptPath "leader-menu"}";
      }
    ];

    tsunami.confs."global-keys" = cfg.global |> builtins.map (f: ''bind-key -n ${f.key} "${escapeShellArg f.exec}"'') |> lib.concatStringsSep "\n";
  };
}

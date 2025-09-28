{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux"; # Hjem only supports NixOS currently
    pkgs = import nixpkgs {inherit system;};
  in {
    hjemModules = rec {
      tsunami = import ./default.nix {
        inherit (nixpkgs) lib;
        inherit pkgs inputs;
        tsunamiLib = import ./lib.nix;
      };
      default = tsunami;
    };
  };
}

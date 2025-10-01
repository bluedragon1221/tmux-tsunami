{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux"; # Hjem only supports NixOS currently
    pkgs = import nixpkgs {inherit system;};
  in {
    hjemModules = rec {
      tsunami = import ./default.nix {
        inherit (nixpkgs) lib;
        inherit pkgs inputs;
        tsunamiLib = import ./lib.nix {inherit (nixpkgs) lib;};
      };
      default = tsunami;
    };
  };
}

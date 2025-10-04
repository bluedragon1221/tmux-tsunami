{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs = inputs: {
    hjemModules.tsunami = ./modules/hjem.nix;

    packages."x86_64-linux".tsunamiInstaller = let
      installer = import ./modules/installer.nix {pkgs = import inputs.nixpkgs {system = "x86_64-linux";};};
    in
      # installer.moduleConfig;
      installer.mkInstaller;
  };
}

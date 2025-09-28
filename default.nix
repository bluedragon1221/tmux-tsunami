{
  tsunamiLib,
  inputs,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.hjem-lib
    ./modules/tsunami.nix
  ];

  _module.args.tsunamiLib = tsunamiLib;
}

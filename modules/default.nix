{config, lib, pkgs, ... }:{
  imports = [
    ./gnome.nix
    ./kde.nix
    ./memory.nix
  ];
}
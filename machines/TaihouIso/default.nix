{ lib, pkgs, modulesPath, ...}:{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  # Just so it works...
  # boot.zfs.package = pkgs.zfs_unstable;
  # TODO: Find out how to set this to the default kernel that the installation profile uses
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_11;
  # Keep my kernel
  environment.systemPackages = with pkgs; [linux-stereomato.kernel];
}
{ lib, pkgs, modulesPath, ...}:{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  # Just so it works...
  # boot.zfs.package = pkgs.zfs_unstable;
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_11;
  environment.systemPackages = with pkgs; [linux-stereomato-newstable.kernel];
}
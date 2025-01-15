{ lib, pkgs, modulesPath, ...}:{
  imports = [
    ./filesystems.nix
   ];

  # nixpkgs.hostPlatform = "x86_64-linux";
  # # Just so it works...
  # # boot.zfs.package = pkgs.zfs_unstable;
  # # TODO: Find out how to set this to the default kernel that the installation profile uses
  # boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_11;
  # # Keep my kernel
  # environment.systemPackages = with pkgs; [linux-stereomato.kernel];

  # Root Disk
  # TODO: Testing with disko
  #boot.initrd.luks.devices."TaihouDisk" = {
		# device = "/dev/disk/by-uuid/6cd37ac7-ae6a-4049-b0a9-4b9bc54c71f3";
	#	allowDiscards = true;
	#	bypassWorkqueues = true;
	#};
}
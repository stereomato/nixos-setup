{ config, pkgs, ... }:{
	boot.kernelParams = [ 
		# Enable HuC
		"i915.enable_guc=2"
		# Powersaving
		"iwlwifi.power_save=1"
		"iwlwifi.power_level=3"
	];
  boot.initrd.luks.devices."HeartsDisk" = {
		device = "/dev/disk/by-uuid/f40dcced-9c73-42f9-9b5c-b250e9e3bb6f";
		allowDiscards = true;
		bypassWorkqueues = true;
	};
	
	networking.hostName = "Hearts";

  users = {
		users = {
			diana = {
				isNormalUser = true;
				createHome = true;
				extraGroups = [ "wheel" "audio" "adbusers" "network" "libvirtd" "networkmanager" "doas" "scanners" "lp" ]; 
				shell = pkgs.fish;
			};
		};
	};

	services = {
		xserver = {
			# Enable for GNOME
			desktopManager.gnome.enable = true;
		};
	};

	fileSystems = {
		"/" = {
			device = "/dev/mapper/HeartsDisk";
			fsType = "btrfs";
			options = [
				"subvol=@"
				"compress=zstd:1"
			];
		};
		"/boot" = {
			device = "/dev/disk/by-uuid/5ADB-0DC5";
			fsType = "vfat";
			options = [
				"discard"
			];
		};
		 "/nix" = {
			device = "/dev/mapper/HeartsDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@nix"
			];
		};
		"/home" = {
			device = "/dev/mapper/HeartsDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@home"
			];
		};
		"/swap" = {
			device = "/dev/mapper/HeartsDisk";
			fsType = "btrfs";
			options = [
				"subvol=@swap"
			];
		};
		"/var/log" = {
			device = "/dev/mapper/HeartsDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:10"
				"subvol=@var_log"
			];
		};
	};
}
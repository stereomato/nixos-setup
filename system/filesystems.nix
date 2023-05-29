{ lib, pkgs, ... }:{
	fileSystems = {
		"/" = {
			device = "/dev/mapper/Taihou-Main";
			fsType = "btrfs";
			options = [
				"subvol=@"
				"compress=zstd:1"
			];
		};
		"/boot" = {
			device = "/dev/disk/by-uuid/9393-3E73";
			fsType = "vfat";
			options = [
				"discard"
			];
		};
		"/nix" = {
			device = "/dev/mapper/Taihou-Main";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@nix"
			];
		};
		"/home" = {
			device = "/dev/mapper/Taihou-Main";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@home"
			];
		};
		"/swap" = { 
			device = "/dev/mapper/Taihou-Main";
			fsType = "btrfs";
			options = [
				"subvol=@swap"
			];
		};
		"/var/log" = { 
			device = "/dev/mapper/Taihou-Main";
			fsType = "btrfs";
			options = [
				"compress=zstd:10"
				"subvol=@var_log"
			];
		};
	};
}
{ lib, pkgs, ... }:{
	fileSystems = {
		"/" = {
			device = "/dev/mapper/Taihou-Disk";
			fsType = "btrfs";
			options = [
				"subvol=@"
				"compress-force=zstd:1"
			];
		};
		"/boot" = {
			device = "/dev/disk/by-uuid/D32C-41BC";
			fsType = "vfat";
			options = [
				"discard"
			];
		};
		"/nix" = {
			device = "/dev/mapper/Taihou-Disk";
			fsType = "btrfs";
			options = [
				"compress-force=zstd:2"
				"subvol=@nix"
			];
		};
		"/home" = {
			device = "/dev/mapper/Taihou-Disk";
			fsType = "btrfs";
			options = [
				"compress-force=zstd:2"
				"subvol=@home"
			];
		};
		"/swap" = { 
			device = "/dev/mapper/Taihou-Disk";
			fsType = "btrfs";
			options = [
				"subvol=@swap"
			];
		};
		"/var/log" = { 
			device = "/dev/mapper/Taihou-Disk";
			fsType = "btrfs";
			options = [
				"compress-force=zstd:10"
				"subvol=@var_log"
			];
		};
	};
}

{ ... }:{
	fileSystems = {
		"/" = {
			device = "/dev/mapper/TaihouDisk";
			fsType = "btrfs";
			options = [
				"subvol=@"
				"compress=zstd:1"
			];
		};
		"/boot" = {
			device = "/dev/disk/by-uuid/B759-D80E";
			fsType = "vfat";
			options = [
				"discard"
			];
		};
		"/nix" = {
			device = "/dev/mapper/TaihouDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@nix"
			];
		};
		"/home" = {
			device = "/dev/mapper/TaihouDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:2"
				"subvol=@home"
			];
		};
		"/swap" = { 
			device = "/dev/mapper/TaihouDisk";
			fsType = "btrfs";
			options = [
				"subvol=@swap"
			];
		};
		"/var/log" = { 
			device = "/dev/mapper/TaihouDisk";
			fsType = "btrfs";
			options = [
				"compress=zstd:10"
				"subvol=@var_log"
			];
		};
	};
}

{ ... }:{
	
	disko.devices = {
		   disk = {
				internalNVME = {
					type = "disk";
					device = "/dev/nvme0n1";
					content = {
						type = "gpt";
						partitions = {
							boot = {
								label = "boot";
								name = "boot";
								size = "512M";
								type = "EF00";
								content = {
									type = "filesystem";
									format = "vfat";
									mountpoint = "/boot";
									mountOptions = [
											"defaults"
											"discard"
									];
								};
							};
							TaihouDisk = {
								size = "100%";
								content = {
									type = "luks";
									name = "TaihouDisk";
									extraOpenArgs = [ "--allow-discards" "--perf-no_read_workqueue" "--perf-no_write_workqueue"  ];
									# if you want to use the key for interactive login be sure there is no trailing newline
									# for example use `echo -n "password" > /tmp/secret.key`
									#passwordFile = "/tmp/secret.key"; # Interactive
									# settings.keyFile = "/tmp/secret.key";
									# additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
									content = {
										type = "btrfs";
										extraArgs = [ "-f" ];
										subvolumes = {
											"@" = {
											mountpoint = "/";
											mountOptions = [ "compress=zstd:1" ];
											};
											"@home" = {
											mountpoint = "/home";
											mountOptions = [ "compress=zstd:1" ];
											};
											"@nix" = {
											mountpoint = "/nix";
											mountOptions = [ "compress=zstd:1" ];
											};
											"@var_log" = {
											mountpoint = "/var/log";
											mountOptions = [ "compress=zstd:1" ];
											};
											"@swap" = {
											mountpoint = "/swap";
											mountOptions = [ "compress=zstd:1" ];
											};
										};
									};
								};
							};
						};
					};

				};

			};
		};

	# These are the pre-disko configs
	# TODO: remove these when I no longer have a use for them
	# fileSystems = {
	# 	"/" = {
	# 		device = "/dev/mapper/TaihouDisk";
	# 		fsType = "btrfs";
	# 		options = [
	# 			"subvol=@"
	# 			"compress=zstd:1"
	# 		];
	# 	};
	# 	"/boot" = {
	# 		device = "/dev/disk/by-uuid/500D-B7A6";
	# 		fsType = "vfat";
	# 		options = [
	# 			"discard"
	# 		];
	# 	};
	# 	 "/nix" = {
	# 		device = "/dev/mapper/TaihouDisk";
	# 		fsType = "btrfs";
	# 		options = [
	# 			"compress=zstd:2"
	# 			"subvol=@nix"
	# 		];
	# 	};
	# 	"/home" = {
	# 		device = "/dev/mapper/TaihouDisk";
	# 		fsType = "btrfs";
	# 		options = [
	# 			"compress=zstd:2"
	# 			"subvol=@home"
	# 		];
	# 	};
	# 	"/swap" = {
	# 		device = "/dev/mapper/TaihouDisk";
	# 		fsType = "btrfs";
	# 		options = [
	# 			"subvol=@swap"
	# 		];
	# 	};
	# 	"/var/log" = {
	# 		device = "/dev/mapper/TaihouDisk";
	# 		fsType = "btrfs";
	# 		options = [
	# 			"compress=zstd:10"
	# 			"subvol=@var_log"
	# 		];
	# 	};
	# };
}

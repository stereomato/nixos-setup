{ config, ... }:{
	
	# TODO: I only want to populate this if we're in the installed system, but what if I'm on install media?
	# Need a way to keep some stuff private to Taihou?
	# Too many ideas...
	disko.devices = if (config.networking.hostName == "Taihou") then {
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
									initrdUnlock = true;
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
	} else {};

	services.udisks2.settings = {
		"mount_options.conf" = {
			"/dev/disk/by-label/stereomato-hdd" = {
				defaults = "lazytime";
				btrfs_defaults = "compress=zstd:5";
			};
		};
	};

	# Other mounts
	# fileSystems = {
	# 	"/mnt/stereomato-hdd" = {
	# 		# device = "/dev/disk/by-uuid/27c24c84-9b54-49fd-83f9-d0b683ad0eb0";
	# 		label = "stereomato-hdd";
	# 		fsType = "btrfs";
	# 		options = [ 
	# 			# This is an HDD, this probably helps a LOT with the slowness inherent to them.
	# 			"compress=zstd:5"
	# 			"lazytime"
	# 			"user"
	# 			"nofail"
	# 			"noauto"
	# 			"x-systemd.automount"
	# 			# Show on GNOME
	# 			"x-gvfs-show"
	# 		];
	# 	};
	# };
}

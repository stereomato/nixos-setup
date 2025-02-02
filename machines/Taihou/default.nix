{ lib, pkgs, modulesPath, ...}:{
  imports = [
    ./filesystems.nix
    ../common
		./boot.nix
		./programs.nix
		../../users/stereomato
		../../users/testuser
  ];

		nixpkgs.overlays = [
			(self: super: {
				ydotool = super.ydotool.overrideAttrs(old: {
					src = super.fetchFromGitHub {
	 					owner = "stereomato";
	 					repo = "ydotool";
	 					rev = "8e8a3d0776b59bf030c45a1458aa55473faa2400";
	 					hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
	 				};
				});
				intel-lpmd = super.callPackage ./extDerivations/intel-lpmd.nix {};
			})
		];

		# Since ADL, Intel cpus have a hybrid core system. I use ADL, so
		# Set this to nproc - 4, so as to at least leave 4 cores free (which would be 1 cluster of E-cores)
		# Now, this will not happen that way actually, but well, still, it'll leave enough space for the UI and whatever I'm using
		# 3/4 of nproc essentially
		# TODO: testing with this not set, since I have 24 GB of ram, 24/48 GB of zswap/zram, and the linux-zen kernel
		# nix.settings.cores = 12;
		networking.hostName = "Taihou";

		systemd = {
			services = {
				adl-smp-affinity-list = {
					enable = true;
					name = "adl-smp-affinity-list.service";
					description = "Set the smp_affinity_list to the last 4 E-cores";
					after = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
					serviceConfig = {
						Type = "oneshot";
						# Some IRQs can't be modified, so use || true to work around this
						ExecStart = "${pkgs.bash}/bin/bash -c 'echo 11-15 | tee /proc/irq/*/smp_affinity_list || true'";
					};
					wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
				};

				battery-charge-threshold = {
					enable = true;
					name = "battery-charge-threshold.service";
					description = "Set the battery charge threshold";
					after = ["multi-user.target"];
					startLimitBurst = 0;
					serviceConfig = {
						Type = "oneshot";
						Restart = "on-failure";
						ExecStart = "${pkgs.bash}/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
					};
					wantedBy = ["multi-user.target"];
				};
			};
			tmpfiles = {
				rules = [
					# Enable HWP dynamic boosting
					# Probably not a good idea
					# "w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
					# Mouse (40,52) and Keyboard (1)
					# Could be handled by intel_lpmd
					# "w /proc/irq/*/smp_affinity_list														- - - - 11-15"
					#"w /proc/irq/40/smp_affinity															- - - - 8000"
					#"w /proc/irq/52/smp_affinity															- - - - 8000"
					#"w /proc/irq/1/smp_affinity															- - - - 8000"
				];
			};
		};


		localModule.gnome.enable = true;

		localModule.performance.memory = {
			zswap = {
				enable = false;
				size = 23726;
			};
			zram = {
				enable = true;
				size = 200;
			};
		};

		services = {
			# intel-lpmd.enable = true;
			# # # intel-lpmd.package = pkgs.intel-lpmd;
			#  intel-lpmd.settings = {
			#  	entry = {
			# 		Mode = "0";
			# 		PerformanceDef = "0";
			# 		BalancedDef = "0";
			# 		PowersaverDef = "0";
			# 		WLTHintEnable = true;
			# 		WLTProxyEnable = true;
			# 		States = [];
			# 	};
			# };

		};

		services.fprintd = {
			enable = true;
			# tod.enable = true;
		};

		environment = {
			sessionVariables = {
				# https://discourse.nixos.org/t/add-ssh-key-to-agent-at-login-using-kwallet/25175/2?u=stereomato
				SSH_ASKPASS_REQUIRE = "prefer";
			};
		};

		# ARGH mouse issues
		programs.ydotool.enable = true;
}

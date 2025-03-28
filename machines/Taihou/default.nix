{ inputs, lib, pkgs, modulesPath, ...}:{
	imports = [
	./filesystems.nix
	../common
	./boot.nix
	./programs.nix
	./containers
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
			bt-mouse-fix = {
				enable = true;
				description = "Fixes the usb suspend mouse problem thing.";
				after = [ "multi-user.target" "powertop.service" ];
				serviceConfig = {
					Type = "oneshot";
					# Using "|| true" in case
					ExecStart = "${pkgs.bash}/bin/bash -c 'echo on | tee \'/sys/bus/usb/devices/1-3/power/control\' || true'";
				};
				wantedBy = [ "multi-user.target" ];
			};

			adl-smp-affinity-list = {
				# Do not enable when using to intel lpmd
				enable = true;
				description = "Set the smp_affinity_list to the E-cores";
				after = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
				serviceConfig = {
					Type = "oneshot";
					# Some IRQs can't be modified, so use || true to work around this
					ExecStart = "${pkgs.bash}/bin/bash -c 'echo 8-15 | tee /proc/irq/*/smp_affinity_list || true'";
				};
				wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
			};

			battery-charge-threshold = {
				enable = true;
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


	localModule.plasma.enable = true;
	localModule.plasma.minimal.enable = false;

	localModule.intel_lpmd.enable = false;
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
		thermald.enable = lib.mkForce false;
		# intel-lpmd.enable = true;
		# # # intel-lpmd.package = pkgs.intel-lpmd;
		# intel-lpmd.settings = ''
		# 	<?xml version="1.0"?>

		# 	<!--
		# 	Specifies the configuration data
		# 	for Intel Energy Optimizer (LPMD) daemon
		# 	-->

		# 	<Configuration>
		# 		<!--
		# 			CPU format example: 1,2,4..6,8-10
		# 		-->
		# 		<lp_mode_cpus></lp_mode_cpus>

		# 		<!--
		# 			Mode values
		# 			0: Cgroup v2
		# 			1: Cgroup v2 isolate
		# 			2: CPU idle injection
		# 		-->
		# 		<Mode>0</Mode>

		# 		<!--
		# 			Default behavior when Performance power setting is used
		# 			-1: force off. (Never enter Low Power Mode)
		# 			1: force on. (Always stay in Low Power Mode)
		# 			0: auto. (opportunistic Low Power Mode enter/exit)
		# 		-->
		# 		<PerformanceDef>-1</PerformanceDef>

		# 		<!--
		# 			Default behavior when Balanced power setting is used
		# 			-1: force off. (Never enter Low Power Mode)
		# 			1: force on. (Always stay in Low Power Mode)
		# 			0: auto. (opportunistic Low Power Mode enter/exit)
		# 		-->
		# 		<BalancedDef>0</BalancedDef>

		# 		<!--
		# 			Default behavior when Power saver setting is used
		# 			-1: force off. (Never enter Low Power Mode)
		# 			1: force on. (Always stay in Low Power Mode)
		# 			0: auto. (opportunistic Low Power Mode enter/exit)
		# 		-->
		# 		<PowersaverDef>0</PowersaverDef>

		# 		<!--
		# 			Use HFI LPM hints
		# 			0 : No
		# 			1 : Yes
		# 		-->
		# 		<HfiLpmEnable>0</HfiLpmEnable>

		# 		<!--
		# 			Use HFI SUV hints
		# 			0 : No
		# 			1 : Yes
		# 		-->
		# 		<HfiSuvEnable>0</HfiSuvEnable>

		# 		<!--
		# 			System utilization threshold to enter LP mode
		# 			from 0 - 100
		# 			clear both util_entry_threshold and util_exit_threshold to disable util monitor
		# 		-->
		# 		<util_entry_threshold>10</util_entry_threshold>

		# 		<!--
		# 			System utilization threshold to exit LP mode
		# 			from 0 - 100
		# 			clear both util_entry_threshold and util_exit_threshold to disable util monitor
		# 		-->
		# 		<util_exit_threshold>95</util_exit_threshold>

		# 		<!--
		# 			Entry delay. Minimum delay in non Low Power mode to
		# 			enter LPM mode.
		# 		-->
		# 		<EntryDelayMS>0</EntryDelayMS>

		# 		<!--
		# 			Exit delay. Minimum delay in Low Power mode to
		# 			exit LPM mode.
		# 		-->
		# 		<ExitDelayMS>0</ExitDelayMS>

		# 		<!--
		# 			Lowest hysteresis average in-LP-mode time in msec to enter LP mode
		# 			0: to disable hysteresis support
		# 		-->
		# 		<EntryHystMS>0</EntryHystMS>

		# 		<!--
		# 			Lowest hysteresis average out-of-LP-mode time in msec to exit LP mode
		# 			0: to disable hysteresis support
		# 		-->
		# 		<ExitHystMS>0</ExitHystMS>

		# 		<!--
		# 			Ignore ITMT setting during LP-mode enter/exit
		# 			0: disable ITMT upon LP-mode enter and re-enable ITMT upon LP-mode exit
		# 			1: do not touch ITMT setting during LP-mode enter/exit
		# 		-->
		# 		<IgnoreITMT>0</IgnoreITMT>

		# 	</Configuration>
		# '';

		ollama = {
			enable = false;
			package = pkgs.ollama-sycl;
			environmentVariables = {
				OLLAMA_INTEL_GPU = "1";
			};
			loadModels = [

			];
		};

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

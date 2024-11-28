{ pkgs, ... }: {
	# Just imports basically
	imports = [
		../common
		./boot.nix
		./filesystems.nix
		./kernel.nix
		./pro-audio.nix
		./programs.nix
		./services.nix
		./users.nix
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
	nix.settings.cores = 12;

	# This was an experiment, trying to build the system for the CPU architecture of my laptop, but IDK if it's worth it.
	# nixpkgs.localSystem.gcc.arch = "alderlake";
	# nixpkgs.localSystem.gcc.tune = "alderlake";
	# nixpkgs.localSystem.system = "x86_64-linux";
	# nix.settings.system-features = [ "gccarch-alderlake" ];
	networking.hostName = "Taihou";

	# Keyboard Layout
	console.keyMap = "la-latin1";

	time = {
		timeZone = "America/Lima";
	};

	systemd = {
		services = {
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
				"w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
				# Mouse (40,52) and Keyboard (1)
				# Could be handled by intel_lpmd
				"w /proc/irq/40/smp_affinity															- - - - 8000"
				"w /proc/irq/52/smp_affinity															- - - - 8000"
				"w /proc/irq/1/smp_affinity															- - - - 8000"
			];
		};
	};
	services = {
		xserver = {
			
			# Keyboard layout
			xkb.layout = "latam";
		};
		
		# Pro Audio things
		udev.extraRules = ''
			# Arduino IDE
			SUBSYSTEMS=="usb-serial", TAG+="uaccess"

			# This is for real time audio
			KERNEL=="cpu_dma_latency", GROUP="audio"
			KERNEL=="rtc0", GROUP="audio"
			KERNEL=="hpet", GROUP="audio"

			# Gotten from https://github.com/pop-os/default-settings/pull/149/commits/efceae50ff5f99d6f621098369116c0015d0f0aa
			# SD card correction from https://github.com/pop-os/default-settings/pull/149#issuecomment-2330321040
			# BFQ is recommended for slow storage such as rotational block devices and SD cards.
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
			ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="mmcblk?", ATTR{removable}=="1", ATTR{queue/scheduler}="bfq"

			# Kyber is recommended for faster storage such as NVME, SATA SSDs and eMMC
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="nvme?n?", ATTR{queue/scheduler}="kyber"
			ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", KERNEL=="sd?", ATTR{queue/scheduler}="kyber"
			ACTION=="add", SUBSYSTEM=="block", KERNEL=="mmcblk?",  ATTR{removable}=="0",           ATTR{queue/scheduler}="kyber"
		'';
	};
	
	services.fprintd = {
		enable = true;
		# tod.enable = true;
	};

	environment = {
		sessionVariables = {
			# https://discourse.nixos.org/t/add-ssh-key-to-agent-at-login-using-kwallet/25175/2?u=stereomato
			SSH_ASKPASS_REQUIRE="prefer";
		};
	};

	# ARGH mouse issues 
	programs.ydotool.enable = true;
}


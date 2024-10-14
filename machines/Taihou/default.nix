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
	];
	
	# nproc / 2 * 3, just in case
	# Not enough ram on my current laptop
	# I think 2GB x thread is good
	# I only have 12GB of ram
	# 6 x 2 = 12, should be fine...
	nix.settings.cores = 6;

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

	services = {
		xserver = {
			# Enable autologin for my user
			displayManager = {
				autoLogin = {
					enable = true;
					user = "stereomato";
				};
			};
			# Keyboard layout
			xkb.layout = "latam";
			desktopManager.gnome = {
				enable = true;
				extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
				extraGSettingsOverrides = ''
					[org.gnome.mutter]
					# Disabled 'rt-scheduler' due to https://gitlab.gnome.org/GNOME/mutter/-/issues/3037
					experimental-features=['scale-monitor-framebuffer']
				'';
			};
		};
		# Pro Audio things
		udev.extraRules = ''
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


}
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
			KERNEL=="cpu_dma_latency", GROUP="audio"
			KERNEL=="rtc0", GROUP="audio"
			KERNEL=="hpet", GROUP="audio"
		'';
	};

	services.fprintd = {
		enable = true;
		# tod.enable = true;
	};


}
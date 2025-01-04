	{ pkgs, ... }: {
		# Just imports basically
		imports = [
			../common
			./boot.nix
			./filesystems.nix
			./programs.nix
			../../users/stereomato
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
		nix.settings.cores = 12;
		networking.hostName = "Taihou";
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
					# Probably not a good idea
					# "w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
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
				# Enable for GNOME
				desktopManager.gnome.enable = true;
			};
			# Enable for KDE
			# Tried enough times, let's leave it disabled until next year
			desktopManager.plasma6.enable = false;
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

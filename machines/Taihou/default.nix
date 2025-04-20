{ config, inputs, lib, pkgs, modulesPath, ...}:{
	imports = [
	./filesystems.nix
	../common
	./boot.nix
	./programs.nix
	./containers
	../../users/stereomato
	../../users/testuser
	];

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
			];
		};
	};


	localModule.gnome.enable = true;
	localModule.gnome.minimal.enable = false;

	localModule.intel_lpmd.enable = false;
	localModule.performance.memory = {
		zswap = {
			enable = false;
			size = 23726;
			hibernation = {
				enable = false;
				device = "/dev/mapper/${config.disko.devices.disk.internalNVME.content.partitions.TaihouDisk.name}";
				resumeOffset = 10828120;
			};
		};
		zram = {
			enable = true;
			size = 200;
		};
	};

	services = {
		mysql = {
			enable = true;
			package = pkgs.mariadb;
		};
		thermald.enable = lib.mkForce false;

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

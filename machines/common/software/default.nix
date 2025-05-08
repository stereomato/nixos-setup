{ config, inputs, lib, pkgs, ... }:{
	imports = [
	];

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [
				"nix-command"
				"flakes"
			];
		} 
		# The aagl substituters
		// inputs.aagl.nixConfig ;
		# Set this thanks to:
		# https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
		registry.nixpkgs.flake = inputs.nixpkgs;
		nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
	};

	services = {
		# Needed for anything GUI
		xserver.enable = true;
		# Web sharing
		samba.enable = false;

		# GPS
		geoclue2 = {
			enable = true;
			# Because MLS is ded, BeaconDB can now be used.
			# Also see https://github.com/NixOS/nixpkgs/issues/321121
			# https://github.com/NixOS/nixpkgs/pull/325430
			geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
			submissionUrl = "https://api.beacondb.net/v2/geosubmit";
			submissionNick = "geoclue";
			# Disabled since I don't have a GPS antenna
			submitData = false;
		};
	 #lib.mkIf (config.services.desktopManager.plasma6.enable)
	};

	programs = {
		firefox.enable = true;
		mtr.enable = true;
		usbtop.enable = true;
		chromium = {
			enable = true;
			enablePlasmaBrowserIntegration = true;
		};
	};

	environment = {
		variables = {
			EDITOR = "nano";
		};
		systemPackages = with pkgs; [
			# System monitoring, managing & benchmarking tools
			intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop clinfo s-tui compsize smartmontools nvme-cli btop pciutils usbutils powertop btrfs-progs nvtopPackages.intel powerstat iotop smem nix-info kdiskmark file stress-ng btop fastfetch cpu-x
			# System management
			gparted

			# Extra
			nano
		];
		sessionVariables = {
			# https://github.com/NixOS/nixpkgs/issues/53631
			# Fixes Kooha, Clapper
			GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
				pkgs.gst_all_1.gstreamer.out
				pkgs.gst_all_1.gst-plugins-base
				pkgs.gst_all_1.gst-plugins-good
				pkgs.gst_all_1.gst-plugins-bad
				pkgs.gst_all_1.gst-plugins-ugly
				pkgs.gst_all_1.gst-libav
				pkgs.gst_all_1.gst-vaapi
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
				pkgs.pkgsi686Linux.gst_all_1.gst-vaapi
				pkgs.pkgsi686Linux.gst_all_1.gst-libav
			];
		};
	};

	i18n = {
		defaultLocale = "es_PE.UTF-8";
		extraLocaleSettings = {
			LANG="en_US.UTF-8";
		};
		extraLocales = [
			"en_US.UTF-8"
		];
	};

	networking = {
		networkmanager = {
			enable = true;
			wifi.backend = "iwd";
		};
		firewall = {
			enable = true;
			allowedUDPPorts = [
				# Syncthing
				22000
				21027
			];
			allowedTCPPorts = [
				# Syncthing
				22000
				# Fragments
				59432
			];
		};
	};

	virtualisation = {
		vmware = {
			# host.enable = true;
		};
		spiceUSBRedirection.enable = true;
		# efi.OVMF = pkgs.OVMFFull;
		libvirtd = {
			enable = true;
			qemu = {
				runAsRoot = false;
				swtpm.enable = true;
				ovmf.packages = [ pkgs.OVMFFull.fd ];
				vhostUserPackages = [ pkgs.virtiofsd ];
			};
			hooks = {
				qemu = {
					# TODO: Should I make this just autostart?
					start-network = pkgs.writers.writeFish "start-network" ''
						set command ${pkgs.libvirt}/bin/virsh
						set default_info ($command net-info default)
						set active (echo $default_info[3] | grep -o -E "yes|no")
						
						if test $active != yes
							$command net-start default
						end
					'';
				};
			};
		};
		podman = {
			enable = true;
		};
		waydroid = {
			enable = true;
		};
	};

	# GPS
	location.provider = "geoclue2";

	security = {
		protectKernelImage = false;
		sudo = {
			enable = true;
		};
		polkit.enable = true;
	};

	documentation = {
		man = {
			generateCaches = true;
			mandoc = {
				enable = false;
			};
			man-db = {
				enable = true;
			};
		};
		dev = {
			enable = true;
		};
	};

	# I am... here
	time = {
		timeZone = "America/Lima";
	};

}

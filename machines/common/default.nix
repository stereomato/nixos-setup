{ config, lib, pkgs, ... }:{
	imports = [
		./fonts.nix
		./hardware
		./software
	];

	# In this place goes things that are too general or too small that putting them in their own files is just cluttering

	#TODO: consider putting high level toggles here?
	# Like, stuff like the toggle for enabling kde or gnome, so that I can put better shaped conditionals on desktop-environment.nix
	console = {
		font = "Lat2-Terminus16";
	};

	
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
			
		} // lib.optionalAttrs (config.services.desktopManager.plasma6.enable) {
			theme = "breeze";
			themePackages = [pkgs.kdePackages.breeze-plymouth];
		};
		
		initrd = {
			availableKernelModules = [ "i915" "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
			};
			systemd.enable = true;
		};
		
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-stereomato;

		kernelParams = [ 
			# Find out whether this is a good idea or not
			# "pcie_aspm=force"
			
			# Debugging i915
			# "drm.debug=0xe" 
			# "log_buf_len=4M" 
			# "ignore_loglevel"
			
			"preempt=full"
			# PSR stuff, should help with battery saving on laptop displays that support this
			"i915.enable_psr=1"
			"i915.enable_psr2_sel_fetch=1"
			# Powersaving
			# "iwlwifi.power_save=1"
			# "iwlwifi.power_level=3"
			# Zswap settings
			"zswap.enabled=Y"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=35"
			"zswap.accept_threshold_percent=90"

			
		];
		loader = {
			systemd-boot = {
				enable = true;
				# configurationLimit = 10;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};
		};
	};

	

	boot = {
		
	};

	programs.fish = {
		enable = true; 
		useBabelfish = true;
	};

	environment = {
		# Create a folder in /etc that has a link to the current NixOS configuration
		# Very good in case of... an accident
		etc."current-nixos".source = ./.;
		localBinInPath = true;
		shells = with pkgs; [ fish ];
	};

	system = {
		# Determines the NixOS version whose format for stateful data will be used.
		# Upgrading this number isn't really neccessary, but possible. Read the NixOS changelogs if so.
		stateVersion = "24.11";
		# Copy the running system's configuration.nix to /run/current-system/configuration.nix
		#copySystemConfiguration = true;
		autoUpgrade = {
			# Can also use the flags knob for adding flags like --upgrade-all. --upgrade is already set, duh.
			# Disable because of the input fonts messing with the execution.
			enable = false;
			dates = "sunday";
			persistent = true;
			operation = "boot";
		};
	};
}

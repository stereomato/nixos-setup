{config, lib, pkgs, ... }:{
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
		} // lib.optionalAttrs (config.services.desktopManager.plasma6.enable) {
			theme = "breeze";
			themePackages = [pkgs.kdePackages.breeze-plymouth];
		};
		initrd = {
			availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ "xe" "i915" ];
			luks = {
				mitigateDMAAttacks = true;
			};
			systemd.enable = true;
		};
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		# kernelPackages = pkgs.linux-stereomato;
		kernelParams = [ 
			# Find out whether this is a good idea or not
			# "pcie_aspm=force"
			
			# Debugging i915
			# "drm.debug=0xe" 
			# "log_buf_len=4M" 
			# "ignore_loglevel"
			
			# Switch to lazy preemption
			# https://lwn.net/Articles/994322/
			"preempt=lazy"

			# Powersaving
			# "iwlwifi.power_save=1"
			# "iwlwifi.power_level=3"
		];
		loader = {
			systemd-boot = {
				enable = true;
			};
			efi = {
				canTouchEfiVariables = true;
				efiSysMountPoint = "/boot";
			};
		};
	};
}

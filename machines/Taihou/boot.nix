{ pkgs, ... }:
{
	#imports = [
	#	./imports/sysctl-tweaks.nix
	#];
	
	boot = {
		plymouth = {
			enable = true;
			font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
		};
		
		initrd = {
			availableKernelModules = [ "i915" "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
				devices = {
					"TaihouDisk" = {
						device = "/dev/disk/by-uuid/f76b90c5-10d5-426a-a43b-cf07ca91b932";
						allowDiscards = true;
						bypassWorkqueues = true;
					};
				};
			};
		};
		
		kernelParams = [ 
			# Find out whether this is a good idea or not
			#"pcie_aspm=force"
			
			# Debugging i915
			#"drm.debug=0xe" 
			#"log_buf_len=4M" 
			#"ignore_loglevel"
			
			"preempt=full"
			# For TGL: only enable the HuC
			# For ADL and up, GuC is enabled automatically.
			# "i915.enable_guc=3"
			# PSR stuff, should help with battery saving on laptop displays that support this
			"i915.enable_psr=1"
			"i915.enable_psr2_sel_fetch=1"
			# "i915.enable_psr=0"
			# "i915.enable_psr2_sel_fetch=1"
			# Powersaving
			# "iwlwifi.power_save=1"
			# "iwlwifi.power_level=3"
			# Zswap settings
			"zswap.enabled=Y"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=35"
			"zswap.accept_threshold_percent=80"
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
}

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
			availableKernelModules = [ "i915" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
			kernelModules = [ ];
			luks = {
				mitigateDMAAttacks = true;
				devices = {
					"TaihouDisk" = {
						device = "/dev/disk/by-uuid/e6857557-edd6-4739-a271-9aed07386607";
						allowDiscards = true;
						bypassWorkqueues = true;
					};
				};
			};
		};
		
		kernelParams = [ 
			# Find out whether this is a good idea or not
			#"pcie_aspm=force"
			"preempt=full"
			# For TGL: only enable the HuC
			# For ADL and up, GuC is enabled automatically.
			"i915.enable_guc=2"
			# PSR stuff, should help with battery saving on laptop displays that support this
			#"i915.enable_psr=1"
			#"i915.enable_psr2_sel_fetch=1"
			"i915.enable_psr=0"
			#"i915.enable_psr2_sel_fetch=1"
			# Powersaving
			"iwlwifi.power_save=1"
			"iwlwifi.power_level=3"
			# Zswap settings
			"zswap.enabled=N"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=25"
			"zswap.accept_threshold_percent=95"
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

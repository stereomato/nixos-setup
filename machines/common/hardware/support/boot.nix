{config, lib, pkgs, ... }:{
  nixpkgs.overlays = [(
		self: super: {
			# Zen kernel
			# TODO: Find where this comes from, and how it works? But, https://github.com/shiryel/nixos-dotfiles/blob/master/overlays/overrides/linux/default.nix# helped a lot!
			linux-stereomato-zen = super.linuxPackages_zen.extend (kself: ksuper: {
				kernel = ksuper.kernel.override {
					argsOverride = {
						structuredExtraConfig = with lib.kernel;
							# Merge the zen kernel's own config with this one using the // operator
							super.linuxPackages_zen.kernel.structuredExtraConfig // {
								# Zswap stuff
								ZSWAP_SHRINKER_DEFAULT_ON = yes;
								ZSMALLOC_STAT = yes;
								# This needs "freeform"
								# from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
								ZSMALLOC_CHAIN_SIZE = freeform "10";
								# mgLRU statistics support
								LRU_GEN_STATS = yes;
								# Compile the kernel with optimizations for my Intel laptop.
								# MNATIVE_INTEL = yes;
								# Extra zram stuff
								ZRAM_MEMORY_TRACKING = yes;
								ZRAM_TRACK_ENTRY_ACTIME = yes;

								# Module compression with ZSTD
								MODULE_COMPRESS_XZ = lib.mkForce no;
								MODULE_COMPRESS_ZSTD = yes;
							};
					};
					ignoreConfigErrors = true;
				};
			});

			# Default
			linux-stereomato = super.linuxPackages_latest.extend (kself: ksuper: {
				kernel = ksuper.kernel.override {
					argsOverride = {
						structuredExtraConfig = with lib.kernel;
							# Merge the kernel's own config with this one using the // operator
							super.linuxPackages_latest.kernel.structuredExtraConfig // {
								# Zswap stuff
								ZSWAP_SHRINKER_DEFAULT_ON = yes;
								ZSMALLOC_STAT = yes;
								# This needs "freeform"
								# from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
								ZSMALLOC_CHAIN_SIZE = freeform "10";
								# mgLRU statistics support
								LRU_GEN_STATS = yes;
								# Compile the kernel with optimizations for my Intel laptop.
								# MNATIVE_INTEL = yes;
								# Extra zram stuff
								ZRAM_MEMORY_TRACKING = yes;
								ZRAM_TRACK_ENTRY_ACTIME = yes;

								# Module compression with ZSTD
								MODULE_COMPRESS_XZ = lib.mkForce no;
								MODULE_COMPRESS_ZSTD = yes;
							};
					};
					ignoreConfigErrors = true;
				};
			});
		}
	)];

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

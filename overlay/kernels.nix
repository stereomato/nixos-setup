let kernelsOverlay = (
	final: prev: {
		# XanMod Kernel
		linux-xanmod-stereomato = prev.linuxPackages_xanmod_latest.extend (kfinal: kprev: {
			kernel = kprev.kernel.override {
				argsOverride = {
					structuredExtraConfig = with prev.lib.kernel;
						# Merge the zen kernel's own config with this one using the // operator
						prev.linuxPackages_xanmod_latest.kernel.structuredExtraConfig // {
							# Zswap stuff
							ZSWAP_SHRINKER_DEFAULT_ON = yes;
							ZSMALLOC_STAT = yes;
							# This needs "freeform"
							# from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
							ZSMALLOC_CHAIN_SIZE = freeform "10";
							# mgLRU statistics support
							LRU_GEN_STATS = yes;
							# Compile the kernel with optimizations for my Intel laptop.
							MALDERLAKE = yes;
							# Extra zram stuff
							ZRAM_MEMORY_TRACKING = yes;
							ZRAM_TRACK_ENTRY_ACTIME = yes;

							# Module compression with ZSTD
							MODULE_COMPRESS_XZ = prev.lib.mkForce no;
							MODULE_COMPRESS_ZSTD = yes;

							# Hibernation compressor set to LZ4
							HIBERNATION_COMP_LZ4 = yes;
							HIBERNATION_DEF_COMP = freeform "lz4";
						};
				};
				ignoreConfigErrors = true;
			};
		});
		# Zen kernel
		# TODO: Find where this comes from, and how it works? But, https://github.com/shiryel/nixos-dotfiles/blob/master/overlays/overrides/linux/default.nix# helped a lot!
		linux-stereomato-zen = prev.linuxPackages_zen.extend (kfinal: kprev: {
			kernel = kprev.kernel.override {
				argsOverride = {
					structuredExtraConfig = with prev.lib.kernel;
						# Merge the zen kernel's own config with this one using the // operator
						prev.linuxPackages_zen.kernel.structuredExtraConfig // {
							# Zswap stuff
							ZSWAP_SHRINKER_DEFAULT_ON = yes;
							ZSMALLOC_STAT = yes;
							# This needs "freeform"
							# from https://github.com/NixOS/nixpkgs/blob/73cf49b8ad837ade2de76f87eb53fc85ed5d4680/pkgs/os-specific/linux/kernel/zen-kernels.nix#L82
							ZSMALLOC_CHAIN_SIZE = freeform "10";
							# mgLRU statistics support
							LRU_GEN_STATS = yes;
							# Compile the kernel with optimizations for my Intel laptop.
							MALDERLAKE = yes;
							# Extra zram stuff
							ZRAM_MEMORY_TRACKING = yes;
							ZRAM_TRACK_ENTRY_ACTIME = yes;

							# Module compression with ZSTD
							MODULE_COMPRESS_XZ = prev.lib.mkForce no;
							MODULE_COMPRESS_ZSTD = yes;

							# Hibernation compressor set to LZ4
							HIBERNATION_COMP_LZ4 = yes;
							HIBERNATION_DEF_COMP = freeform "lz4";
						};
				};
				ignoreConfigErrors = true;
			};
		});

		# Default
		linux-stereomato = prev.linuxPackages_latest.extend (kfinal: kprev: {
			kernel = kprev.kernel.override {
				argsOverride = {
					structuredExtraConfig = with prev.lib.kernel;
						# Merge the kernel's own config with this one using the // operator
						prev.linuxPackages_latest.kernel.structuredExtraConfig // {
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
							MODULE_COMPRESS_XZ = prev.lib.mkForce no;
							MODULE_COMPRESS_ZSTD = yes;

							# Hibernation compressor set to LZ4
							HIBERNATION_COMP_LZ4 = yes;
							HIBERNATION_DEF_COMP = freeform "lz4";
						};
				};
				ignoreConfigErrors = true;
			};
		});
	}
);
in kernelsOverlay
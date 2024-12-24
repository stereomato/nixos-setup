{ lib, pkgs, ... }:{
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
								# Fedora configuration mimicking
								#RV = yes;
								#TRACE_EVAL_MAP_FILE = yes;
								#RING_BUFFER_BENCHMARK = module;
								#HIST_TRIGGERS = yes;
								#SYNTH_EVENTS = yes;
								#HWLAT_TRACER = yes;
								#OSNOISE_TRACER = yes;
								#TIMERLAT_TRACER = yes;
								#BOOTTIME_TRACING = yes;
								#MMIOTRACE = yes;
								#LATENCYTOP = yes;
								#RCU_TORTURE_TEST = module;
								#BUG_ON_DATA_CORRUPTION = yes;
								#LOCK_TORTURE_TEST = module;
								#SCHEDSTATS = yes;
								#HARDLOCKUP_DETECTOR = yes;
								#SOFTLOCKUP_DETECTOR = yes;
								#WATCH_QUEUE = yes;
								#6PACK = module;
								# PCIE Advanced Error Reporting
								PCIEAER = yes;
								# Extra ACPI features
								ACPI_APEI_MEMORY_FAILURE = yes;
								ACPI_APEI_PCIEAER = yes;
								ACPI_I2C_OPREGION = yes;
								# I2C built-in is needed by ACPI_I2C_OPREGION
								I2C = yes;
								# Extra DMABUF features
								DMABUF_HEAPS = yes;
								DMABUF_HEAPS_CMA = yes;
								DMABUF_HEAPS_SYSTEM = yes;
								# Enable compressors to use with zswap or zram.
								CRYPTO_ZSTD = yes;
								ZSTD_COMPRESS = yes;
								CRYPTO_LZ4 = yes;
								LZ4_COMPRESS = yes;
								CRYPTO_LZ4HC = yes;
								LZ4HC_COMPRESS = yes;
								# Zswap stuff
								ZSWAP_SHRINKER_DEFAULT_ON = yes;
								ZSMALLOC_STAT = yes;
								# mgLRU statistics support
								LRU_GEN_STATS = yes;
								# Compile the kernel with optimizations for my Intel laptop.
								MNATIVE_INTEL = yes;
								# Extra zram stuff
								ZRAM_MEMORY_TRACKING = yes;
								ZRAM_MULTI_COMP = yes;

								# Module compression with ZSTD
								MODULE_COMPRESS_XZ = lib.mkForce no;
								MODULE_COMPRESS_ZSTD = yes;
							};
					};
					
					ignoreConfigErrors = true;
				};
			});

			# Default
			linux-stereomato = super.linuxPackages_6_12.extend (kself: ksuper: {
				kernel = ksuper.kernel.override {
					argsOverride = {
						structuredExtraConfig = with lib.kernel;
							# Merge the zen kernel's own config with this one using the // operator
							super.linuxPackages_zen.kernel.structuredExtraConfig // {
								# Fedora configuration mimicking
								#RV = yes;
								#TRACE_EVAL_MAP_FILE = yes;
								#RING_BUFFER_BENCHMARK = module;
								#HIST_TRIGGERS = yes;
								#SYNTH_EVENTS = yes;
								#HWLAT_TRACER = yes;
								#OSNOISE_TRACER = yes;
								#TIMERLAT_TRACER = yes;
								#BOOTTIME_TRACING = yes;
								#MMIOTRACE = yes;
								#LATENCYTOP = yes;
								#RCU_TORTURE_TEST = module;
								#BUG_ON_DATA_CORRUPTION = yes;
								#LOCK_TORTURE_TEST = module;
								#SCHEDSTATS = yes;
								#HARDLOCKUP_DETECTOR = yes;
								#SOFTLOCKUP_DETECTOR = yes;
								#WATCH_QUEUE = yes;
								#6PACK = module;
								# PCIE Advanced Error Reporting
								PCIEAER = yes;
								# Extra ACPI features
								ACPI_APEI_MEMORY_FAILURE = yes;
								ACPI_APEI_PCIEAER = yes;
								ACPI_I2C_OPREGION = yes;
								# I2C built-in is needed by ACPI_I2C_OPREGION
								I2C = yes;
								# Extra DMABUF features
								DMABUF_HEAPS = yes;
								DMABUF_HEAPS_CMA = yes;
								DMABUF_HEAPS_SYSTEM = yes;
								# Enable compressors to use with zswap or zram.
								CRYPTO_ZSTD = yes;
								ZSTD_COMPRESS = yes;
								CRYPTO_LZ4 = yes;
								LZ4_COMPRESS = yes;
								CRYPTO_LZ4HC = yes;
								LZ4HC_COMPRESS = yes;
								# Zswap stuff
								ZSWAP_SHRINKER_DEFAULT_ON = yes;
								ZSMALLOC_STAT = yes;
								# mgLRU statistics support
								LRU_GEN_STATS = yes;
								# Compile the kernel with optimizations for my Intel laptop.
								# MNATIVE_INTEL = yes;
								# Extra zram stuff
								ZRAM_MEMORY_TRACKING = yes;
								ZRAM_MULTI_COMP = yes;

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
		kernelModules = [ "kvm-intel" ];
		extraModulePackages = [ ];
		kernelPackages = pkgs.linux-stereomato;
		
		#kernelPatches = [
			# Might work in kernel 6.7
		#	{
		#		name = "FBC patch";
		#		patch = ./patches/drm-i915-fbc-Allow-FBC-with-CCS-modifiers-on-SKL.patch;
		#	}
		#];
	};
}

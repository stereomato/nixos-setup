{ lib, pkgs, ... }:
{
	nixpkgs = {
		config = {
			allowUnfree = true;
			joypixels.acceptLicense = true;
			input-fonts.acceptLicense = true;
			permittedInsecurePackages = [
					"openssl-1.1.1w"
			];
		};
		overlays = [(
			self: super: {
				# UGLY, see: https://github.com/NixOS/nix/pull/2911
				# Also, see: https://github.com/NixOS/nixpkgs/issues/214848
				emoji-removal = super.writeScriptBin "emoji-removal" ''
          #!/usr/bin/env -S ${super.fontforge}/bin/fontforge -lang=ff -script 
          Open($1)
          SetTTFName(0x409,13,"")
          Select(0u2600,0u26ff)
          DetachAndRemoveGlyphs()
          Generate($1)
          Select(0u2700,0u27bf)
          DetachAndRemoveGlyphs()
          Generate($1)
          Select(0u10000,0u1fffd)
          DetachAndRemoveGlyphs()
          Generate($1)
        '';
				iosevka-pearsche = super.iosevka.override {
					privateBuildPlan = {
						family = "Pearsche's Iosevka setup";
						spacing = "normal";
						serifs = "sans";
						no-cv-ss = false;
						export-glyph-names = true;
						no-ligation = true;
						variants = {
							design = {
								capital-g = "toothed-serifless-hooked";
								capital-j = "serifed";
								capital-q = "crossing-baseline";
								f = "flat-hook-serifless";
								g = "single-storey-flat-hook-serifless";
								r = "serifed";
								t = "flat-hook-short-neck2";
								eight = "two-circles";
								at = "fourfold-solid-inner";
							};
						};
						widths.normal = {
							shape = 500;
							menu = 5;
							css = "normal";
						};
						widths.extended = {
							shape = 600;
							menu = 7;
							css = "expanded";
						};
						widths.condensed = {
							shape = 416;
							menu = 3;
							css = "condensed";
						};
						widths.semicondensed = {
							shape = 456;
							menu = 4;
							css = "semi-condensed";
						};
						widths.semiextended = {
							shape = 548;
							menu = 6;
							css = "semi-expanded";
						};
						widths.extraextended = {
							shape = 658;
							menu = 8;
							css = "extra-expanded";
						};
						widths.ultraextended = {
							shape = 720;
							menu = 9;
							css = "ultra-expanded";
						};
					};
					set = "Iosevka-Pearsche";
				};
				SF-Pro = super.callPackage ./derivationsYetToUpstream/SF-Pro.nix {};
				SF-Compact = super.callPackage ./derivationsYetToUpstream/SF-Compact.nix {};
				SF-Mono = super.callPackage ./derivationsYetToUpstream/SF-Mono.nix {};
				SF-Arabic = super.callPackage ./derivationsYetToUpstream/SF-Arabic.nix {};
				New-York = super.callPackage ./derivationsYetToUpstream/New-York.nix {};
				Bitter-Pro = super.callPackage ./derivationsYetToUpstream/Bitter-Pro.nix {};
				Playfair-Display = super.callPackage ./derivationsYetToUpstream/Playfair-Display.nix {};
				ANRT-Baskervville = super.callPackage ./derivationsYetToUpstream/ANRT-Baskervville.nix {};
				input-fonts = super.input-fonts.overrideAttrs (old: {
					pname = "${super.input-fonts.pname}";
					version = "${super.input-fonts.version}";
					src =
						super.fetchzip {
							name = "${super.input-fonts.pname}-${super.input-fonts.version}";
							url = "https://input.djr.com/build/?fontSelection=whole&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email=&.zip";
							sha256 = "1iq98bvdljiz1rqrxk2r3k06q9m1gv90bnyri8zxfjmpmihs10cp";
							stripRoot = false;
						};
					
				});
				# TODO: Find where this comes from, and how it works? But, https://github.com/shiryel/nixos-dotfiles/blob/master/overlays/overrides/linux/default.nix# helped a lot!
				linux-pearsche = super.linuxPackages_zen.extend (kself: ksuper: {
					kernel = ksuper.kernel.override { 
						structuredExtraConfig = with lib.kernel; {
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
							# Memory failure recovery
							MEMORY_FAILURE = yes;
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
							Z3FOLD = yes;
							ZSMALLOC = lib.mkForce yes;
							ZSMALLOC_STAT = yes;
							# mgLRU statistics support
							LRU_GEN_STATS = yes;
							# Compile the kernel with optimizations for my Intel laptop.
							#TODO: Disabled because I'm currently using the vanilla 6.3 kernel
							#MNATIVE_INTEL = yes;
							# Extra zram stuff
							ZRAM_MEMORY_TRACKING = yes;
							ZRAM_MULTI_COMP = yes;

							# Accelerator subsystem
							DRM_ACCEL = yes;
						};
						#	ignoreConfigErrors = true;
					};
				});
				steam = super.steam.override {
							extraPkgs = pkgs: with pkgs; [
								openssl_1_1
								curl
								libssh2
								openal
								zlib
								libpng
								# https://github.com/NixOS/nixpkgs/issues/236561
								attr
							];
				};
				optimizeIntelCPUperformancePolicy = pkgs.writers.writeFishBin "scriptOptimizeIntelCPUperformancePolicy" ''
					set -l options 'mode=?'
					argparse $options -- $argv
					set bootComplete (systemctl is-active graphical.target)
					while test $bootComplete != "active"
						sleep 1
						set bootComplete (systemctl is-active graphical.target)
					end

					if test -n "$_flag_mode"
						if test "$_flag_mode" = "battery" -o "$_flag_mode" = "charger" -o "$_flag_mode" = "testing"
							switch $_flag_mode
								case battery
									set preference balance_power
								case charger
									set preference balance_performance
								case testing
									set preference 160
							end
							echo $preference | tee /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference
						else
							echo "You need to provide a proper mode for this script to actually do something, either --mode=charger or --mode=battery."
							return 1
						end
					else
						echo "You need to provide a mode for this script to actually do something, either --mode=charger or --mode=battery."
						return 1
					end
				'';
				threadsFile = pkgs.runCommandLocal "cores-for-hardware-config" {} '' 
					mkdir $out
					nproc | tr -d '\n' | tee $out/numThreads
					echo '''$(($(nproc) / 2 ))| tr -d '\n' | tee $out/halfNumThreads
				'';
			}
		)];
	};
}

{ lib, pkgs, ... }:{
  
	nixpkgs.overlays = [(
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
					xorg.libXcursor
					xorg.libXi
					xorg.libXinerama
					xorg.libXScrnSaver
					libpng
					libpulseaudio
					libvorbis
					stdenv.cc.cc.lib
					libkrb5
					keyutils
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
			nvtop = super.nvtop.override {
				nvidia = false;
			};
			
			#qadwaitadecorations = super.qadwaitadecorations.override {
				# qt5ShadowsSupport = true;
			#};
			jdk17 = super.jdk17.override {
				enableJavaFX = true;
			};

			
		}
	)];
}

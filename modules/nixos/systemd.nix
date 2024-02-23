{ pkgs, lib, ... }:
{
	home-manager.users.stereomato.	# Placeholder
	systemd.user = {
		sessionVariables = {
			# PATHs for DAW plugins
			DSSI_PATH   = "$HOME/.dssi:/etc/profiles/per-user/stereomato/lib/dssi:/run/current-system/sw/lib/dssi";
			LADSPA_PATH = "$HOME/.ladspa:/etc/profiles/per-user/stereomato/lib/ladspa:/run/current-system/sw/lib/ladspa";
			LV2_PATH    = "$HOME/.lv2:/etc/profiles/per-user/stereomato/lib/lv2:/run/current-system/sw/lib/lv2";
			LXVST_PATH  = "$HOME/.lxvst:/etc/profiles/per-user/stereomato/lib/lxvst:/run/current-system/sw/lib/lxvst:$HOME/.vst:/etc/profiles/per-user/stereomato/lib/vst:/run/current-system/sw/lib/vst";
			VST_PATH    = "$HOME/.vst:/etc/profiles/per-user/stereomato/lib/vst:/etc/profiles/per-user/stereomato/lib/vst3:/run/current-system/sw/lib/vst";
			# Enable wayland for some apps that don't default to wayland yet
			QT_QPA_PLATFORM = "wayland";
			MOZ_ENABLE_WAYLAND = "1";
			NIXOS_OZONE_WL = "1";
			# Show FPS in games/apps that use DXVK
			DXVK_HUD="fps";
			# Enable some extra Kooha features.
			KOOHA_EXPERIMENTAL = "1";
			# Use the symengine in a python thing
			USE_SYMENGINE = "1";
			# Stop wine from making menu entries.
			WINEDLLOVERRIDES = "winemenubuilder.exe=d";
			# QT bug https://bugreports.qt.io/browse/QTBUG-113574
			QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
			# Disable this, it breaks many games and perhaps even software. 
			#	SDL_VIDEODRIVER = "wayland";
			#
			# https://github.com/NixOS/nixpkgs/issues/53631
			# Fixes Kooha, Clapper
			GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
				pkgs.gst_all_1.gst-plugins-base
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
				pkgs.gst_all_1.gst-plugins-good
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
				pkgs.gst_all_1.gst-plugins-bad
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
				pkgs.gst_all_1.gst-plugins-ugly
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
				pkgs.gst_all_1.gst-libav
				pkgs.pkgsi686Linux.gst_all_1.gst-libav
				pkgs.gst_all_1.gst-vaapi
				pkgs.pkgsi686Linux.gst_all_1.gst-vaapi
			];
			EDITOR = "code --wait --new-window";
		};
		services = {
			home-manager-gc = {
				Unit = {
					Description = "Service that garbage collects the home-manager setup for my user";
					After = "nix-gc.service";
				};
				Service = {
					ExecStart = "${pkgs.home-manager-gc-start}/bin/home-manager-gc-start";
				};
			};
		};
		timers = {
			home-manager-gc = {
				Unit = {
					Description = "Weekly timer for home-manager-gc";
				};
				Timer = {
					OnCalendar = "sunday";
					# Copying the same stuff on the nix-gc timer
					Persistent = true;
					RandomizedDelaySec = 0;
				};
				Install = {
					WantedBy = [ 
						"timers.target"
					];
				};
			};
		};
	};


	systemd = {
		tmpfiles = {
			# Enable HWP dynamic boosting
			rules = [ 
				"w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
			];
		};
		oomd = {
			#TODO: Keep an eye on https://github.com/NixOS/nixpkgs/pull/225747
			# Enabled by default
			# enable = true;
			# This is enabled by fedora
			enableSystemSlice = true;
			enableUserSlices = true;
			# This is not
			# enableRootSlice = true;
			extraConfig = {
				DefaultMemoryPressureLimit = "85%";
				SwapUsedLimit = "75%";
			};
		};
	};
}
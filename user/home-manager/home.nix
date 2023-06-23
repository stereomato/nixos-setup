{ currentUsername, lib, pkgs, ... }:

{
	imports = [
	];
	home = {
		username = currentUsername;
		homeDirectory = "/home/${currentUsername}";
		packages = with pkgs; [
			
			# TODO: Organize better

			# Cryptocurrency
			monero-gui xmrig-mo
			# Need to report it so it gets fixed
			#oxen
			
			# Zrythm bug https://github.com/NixOS/nixpkgs/issues/184839
			libsForQt5.breeze-icons

			# System monitoring, managing & benchmarking tools
			intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop gtop clinfo s-tui neofetch compsize smartmontools nvme-cli btop pciutils usbutils gnome.gnome-power-manager powertop btrfs-progs file stress-ng nvtop
			
      # System management
      
      # Virtualization and containerization
			distrobox gnome.gnome-boxes
			
			# Requires nixos/nixpkgs newer than 22.11
			toolbox

			# Password management
			bitwarden bitwarden-cli 
			
			# File compressors
			rar p7zip
			
			# Miscellanous Gnome apps
			gnome-icon-theme gnome.gnome-tweaks gnome-extension-manager metadata-cleaner warp wike gnome-solanum newsflash 
	
			# Miscellanous cli apps
			xorg.xeyes maigret bc xdg-utils

			# Font management
			fontforge font-manager
			
			# Windows related stuff
			wineWowPackages.stagingFull dxvk  winetricks proton-caller bottles


			## Software development
			# Compilers, configurers
			patchelf

			# Terminals
			blackbox-terminal

			# Nix tooling
			rnix-lsp nix-prefetch-scripts niv nixd

			# Debuggers
			gdb valgrind

			# Code editors/IDEs
			netbeans micro

			# Documentation tools
			
			# Java libraries
			commonsIo

			# Internet tools
			curl wget aria fragments giara megacmd
			
			# VPN
			protonvpn-gui
			
			# Text editors
			nano gnome-text-editor
			
			# Office and LaTeX
			libreoffice-fresh onlyoffice-bin apostrophe 
			
			# QTWebkit shit
			#mendeley
			
			# Games & Fun
			# minecraft (official launcher) https://github.com/NixOS/nixpkgs/issues/179323
			waifu2x-converter-cpp minecraft prismlauncher xonotic protontricks sl vintagestory stuntrally
			
			# Emulators
			citra-nightly dolphin-emu-beta ppsspp-sdl-wayland
			# Multimedia Libs (commenting out because supposedly we're not supposed to install libs here)
			# gnome-video-effects gst_all_1.gstreamer gst_all_1.gst-libav gst_all_1.gst-vaapi gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-ugly 
			
			# Multimedia

			# Image encoders
			libjxl libavif

			# Gstreamer programs
			gst_all_1.gstreamer

			# Digital books (epubs, manga)
			foliate
			
			# Music/Audio file management
			# Adding both normal ffmpeg and ffmpeg_5 because at time of writing (14-oct-22) default ffmpeg is 4.4.2
			wavpack mac fdk-aac-encoder lame flac freac opusTools opustags flacon easytag spek
			
			
			# General multimedia tools
			mediainfo  ffmpeg-fuller 
			# broken: handbrake-pearsche https://github.com/NixOS/nixpkgs/pull/235822

			# Digital media players/readers/streamers
			celluloid clapper amberol quodlibet syncplay rhythmbox spotify gthumb

			# Screen/Video recorders
			obs-studio-with-plugins simplescreenrecorder kooha

			# Music production: DAWs
			audacity ardour qpwgraph
			# zrythm

			# Music production: plugins
			dragonfly-reverb distrho lsp-plugins x42-plugins chowmatrix auburn-sounds-graillon-2 tal-reverb-4
			
			# Video Production & manipulation
			pitivi  mkvtoolnix kdenlive
			# bug 226671 @ nixpkgs
			# davinci-resolve
			
			# Web Browsers
			google-chrome vivaldi vivaldi-ffmpeg-codecs 
			
			# Ask for it to be fixed someday
			#vivaldi-widevine 

			# Chat apps
			element-desktop cinny-desktop tdesktop  discord gnome.polari dino session-desktop mumble fractal
			
			# Fediverse apps
			whalebird
			
			# Image creation and manipulation
			# gimp-with-plugins https://github.com/NixOS/nixpkgs/pull/210937
			# imagemagickBig is the one that includes ghostscript
			drawing gimp imagemagickBig realesrgan-ncnn-vulkan gnome-obfuscate eyedropper

			# Phone stuff
			scrcpy 
		];
		sessionVariables = {
			# Enable wayland for some apps that don't default to wayland yet
			QT_QPA_PLATFORM = "wayland";
			MOZ_ENABLE_WAYLAND = "1";
			NIXOS_OZONE_WL = "1";
			DXVK_HUD="fps";
			# Enable some extra Kooha features.
			KOOHA_EXPERIMENTAL = "1";
			USE_SYMENGINE = "1";
			# Stop wine from making menu entries.
			WINEDLLOVERRIDES = "winemenubuilder.exe=d";
			# QT bug https://bugreports.qt.io/browse/QTBUG-113574
			QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
			# Disable this, it breaks many games and perhaps even software. 
			#	SDL_VIDEODRIVER = "wayland";
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
		};
		
		# Broken https://github.com/nix-community/home-manager/issues/3417
		# environment.localBinInPath for configuration.nix exists anyway.
		#sessionPath = [
		#	"$HOME/.local/bin"
		#];
		
		# Version that the installed home-manager is compatible with.
    # Update notes talk about it.
		stateVersion = "22.11";
	};
}

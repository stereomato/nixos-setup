{ config, pkgs, inputs, ... }:

{
	imports = [
	];
	home = {
		username = "stereomato";
		homeDirectory = "/home/stereomato";
		packages = with pkgs; [
			
			# TODO: Organize better
		
			# AI stuff
			inputs.nixified-ai.packages.x86_64-linux.invokeai-amd

			# Cryptocurrency
			monero-gui # xmrig-mo
			# Need to report it so it gets fixed
			#oxen
			
			# Zrythm bug https://github.com/NixOS/nixpkgs/issues/184839
			libsForQt5.breeze-icons

			# System monitoring, managing & benchmarking tools
			intel-gpu-tools libva-utils mesa-demos vulkan-tools lm_sensors htop gtop clinfo s-tui neofetch compsize smartmontools nvme-cli btop pciutils usbutils gnome.gnome-power-manager powertop btrfs-progs file stress-ng nvtop-intel powerstat iotop smem nix-info
			
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
			xorg.xeyes 
			# FTBFS: nix log /nix/store/1swy5s502g4ygqyb799c14vd9z67b5fw-python3.11-certomancer-0.11.0.drv
			# maigret 
			bc xdg-utils

			# Miscellanous stuff...
			open-in-mpv

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
			rnix-lsp nix-prefetch-scripts niv nixd nil

			# Debuggers
			gdb valgrind

			# Code editors/IDEs
			netbeans micro 

			# Documentation tools
			zeal
			
			# Java libraries
			commonsIo

			# Internet tools
			curl wget aria fragments megacmd
			
			# VPN
			protonvpn-gui
			
			# Text editors
			nano gnome-text-editor
			
			# Office and LaTeX
			libreoffice-fresh onlyoffice-bin_latest gnome-latex 
			# bug https://github.com/NixOS/nixpkgs/issues/249946
			# apostrophe 
			
			# QTWebkit shit
			#mendeley
			
			# Games & Fun
			# minecraft (official launcher) https://github.com/NixOS/nixpkgs/issues/179323
			waifu2x-converter-cpp minecraft prismlauncher protontricks sl vintagestory stuntrally tome4
			
			# Emulators
			dolphin-emu-beta ppsspp-sdl-wayland citra-nightly pcsx2
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
			mediainfo ffmpeg-fuller handbrake-stereomato

			# Digital media players/readers/streamers
			celluloid clapper amberol quodlibet rhythmbox spotify gthumb syncplay
			
			# Screen/Video recorders
			obs-studio-with-plugins simplescreenrecorder kooha

			# Music production: DAWs
			audacity ardour qpwgraph reaper 
			# FTBFS: nix log /nix/store/9rfkwm2k1sd4x8yy50bhni7ffjd7ar0n-zrythm-1.0.0-beta.4.9.1.drv
			# zrythm

			# Music production: plugins
			dragonfly-reverb distrho lsp-plugins x42-plugins chowmatrix auburn-sounds-graillon-2 tal-reverb-4 calf CHOWTapeModel zam-plugins gxplugins-lv2 tap-plugins
			
			# Video Production & manipulation
			kdenlive mkvtoolnix davinci-resolve 
			# FTBFS: https://github.com/NixOS/nixpkgs/pull/285803
			pitivi 
			olive-editor flowblade
			
			# Web Browsers
			google-chrome vivaldi vivaldi-ffmpeg-codecs 
			
			# Ask for it to be fixed someday
			#vivaldi-widevine 

			# Chat apps
			tdesktop discord gnome.polari mumble fractal element-desktop dino
			
			# Fediverse apps
			
			
			# Image creation and manipulation
			# imagemagickBig is the one that includes ghostscript
			drawing gimp-with-plugins imagemagickBig 
			
			# FTBFS: nix log /nix/store/r3yc4j7a5yrzj5d6hvgz762r52w6b3mz-Real-ESRGAN-ncnn-vulkan-0.2.0.drv
			#realesrgan-ncnn-vulkan 
			gnome-obfuscate eyedropper


			# Phone stuff
			scrcpy

			# Computer Graphics
			blender

			# Gamedev
			unityhub godot3-mono godot3-mono-export-templates
			## This is for godot's C# support
			msbuild

			# Life managing
			gtg 
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers
		];
		
		# Broken https://github.com/nix-community/home-manager/issues/3417
		# environment.localBinInPath for configuration.nix exists anyway.
		#sessionPath = [
		#	"$HOME/.local/bin"
		#];
		
		file."current-hm".source = ./.;
		# Symlink configuration files for programs that modify their settings at runtime/exit
		# https://github.com/nix-community/home-manager/issues/3514
		# FIXME: Some of these configurations can be handled better, so, do that.
		file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/btop;
		file.".config/htop".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/htop;
		file.".config/easyeffects".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/easyeffects;
		file.".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/neofetch;
		file.".config/xmrig-mo".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/xmrig-mo;
		file.".config/MangoHud".source = config.lib.file.mkOutOfStoreSymlink ./to-symlink/MangoHud;
		# Version that the installed home-manager is compatible with.
    # Update notes talk about it.
		stateVersion = "23.11";


	# Workaround for cursors broken in gnome by default
	# affects: mpv and games it seems
		pointerCursor = {
			package = pkgs.gnome.adwaita-icon-theme;
			name = "Adwaita";
			size = 24;
			gtk.enable = true;
			x11.enable = true;
		};

	};
}

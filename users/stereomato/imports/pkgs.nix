{ pkgs, inputs, ... }:{
	home.packages = with pkgs; [
			
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
			# FIXME: nixd https://github.com/nix-community/nixd/issues/357
			nix-prefetch-scripts niv nil

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
			waifu2x-converter-cpp minecraft prismlauncher protontricks sl vintagestory stuntrally tome4 gamescope
			
			# Emulators
			# rip citra-nightly
			dolphin-emu-beta ppsspp-sdl-wayland pcsx2
			# Multimedia Libs (commenting out because supposedly we're not supposed to install libs here)
			# gnome-video-effects gst_all_1.gstreamer gst_all_1.gst-libav gst_all_1.gst-vaapi gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-ugly 
			
			# Multimedia

			# Gstreamer programs
			gst_all_1.gstreamer

			# Digital books (epubs, manga)
			foliate
			
			
			
			# General multimedia tools
			mediainfo ffmpeg-fuller handbrake-stereomato

			
			
			# Web Browsers
			google-chrome vivaldi vivaldi-ffmpeg-codecs 
			
			# Ask for it to be fixed someday
			#vivaldi-widevine 

			# Chat apps
			tdesktop discord gnome.polari mumble fractal element-desktop dino
			
			# Fediverse apps
			
			
			
			
			


			# Phone stuff
			scrcpy

			

			# Life managing
			gtg 
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers
		];
}
{ taihouConfig, pkgs, inputs, ... }:{
  imports = [
    ./gaming.nix
    ./internet.nix
  ];

  # Stuff that I either don't know where to put or doesn't have enough items to be put in their own file
  home.packages = with pkgs; [
			
			# TODO: Organize better
	
			# AI stuff
			#inputs.nixified-ai.packages.x86_64-linux.invokeai-amd

			# Cryptocurrency
			monero-gui xmrig-mo
			# Need to report it so it gets fixed
			#oxen
			
			# Zrythm bug https://github.com/NixOS/nixpkgs/issues/184839
			libsForQt5.breeze-icons

			# File compressors
			rar p7zip
			
			# Miscellanous cli apps
			xorg.xeyes 
			# FTBFS: nix log /nix/store/1swy5s502g4ygqyb799c14vd9z67b5fw-python3.11-certomancer-0.11.0.drv
			# maigret 
			bc xdg-utils trash-cli
			
			

			# Text editors
			nano 
			# gnome-text-editor
			
			# Office and LaTeX
			# 
			# 
			onlyoffice-bin_latest 
			 #apostrophe
			
			# QTWebkit shit
			#mendeley
			
			# Phone stuff
			scrcpy
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers

			# Uni
			octaveFull
		] ++ lib.optionals taihouConfig.services.desktopManager.plasma6.enable [
			libreoffice-qt-fresh
		 ]
		++ lib.optionals taihouConfig.services.xserver.desktopManager.gnome.enable [
			libreoffice-fresh
			
			# gnome stuff
			metadata-cleaner warp wike gnome-solanum newsflash

			enter-tex

			# Life managing
			gtg

			# Font management
			fontforge-gtk
			# FTBFS nix log /nix/store/q7yjb9yhxq2n2lzfihd12mswpr8igi3i-font-manager-0.8.8.drv
			# font-manager
		 ];
}

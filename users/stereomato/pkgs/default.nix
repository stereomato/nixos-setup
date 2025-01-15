{config, lib, pkgs, ...}:{
  imports = [
    ./imports
    ./media
    ./gaming.nix
    ./internet.nix
	./software-development.nix
  ];
  users.users.stereomato.packages = with pkgs; [
		
		# TODO: Organize better

			# Virt
			virt-manager
			# AI stuff
			#inputs.nixified-ai.packages.x86_64-linux.invokeai-amd

			# Cryptocurrency
			monero-gui xmrig-mo

			# File compressors
			rar p7zip

			# Miscellanous cli apps
			xorg.xeyes maigret
			bc xdg-utils trash-cli

			# Text editors
			nano
			# gnome-text-editor

			# Office and LaTeX
			onlyoffice-bin_latest

			# QTWebkit shit
			#mendeley

			# Phone stuff
			scrcpy
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers

			# Uni
			octaveFull
		] ++ lib.optionals config.services.desktopManager.plasma6.enable [
			libreoffice-qt-fresh
		 ]
		++ lib.optionals config.services.xserver.desktopManager.gnome.enable [
			libreoffice-fresh

			# gnome stuff
			metadata-cleaner warp wike gnome-solanum newsflash

			enter-tex

			# Life managing
			gtg

			# Font management
			fontforge-gtk
		 ];

}

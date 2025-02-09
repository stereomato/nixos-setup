{config, lib, pkgs, ...}:{
  imports = [
    ./imports
    ./media
    ./gaming.nix
    ./internet.nix
	./software-development.nix
  ];

	nixpkgs.overlays = [(self: super: {
		alpaca = super.alpaca.overridePythonAttrs(old: rec {
			version = "4.0.1";
			src = super.fetchFromGitHub {
    		owner = "Jeffser";
    		repo = "Alpaca";
    		tag = version;
    		hash = "sha256-BTTqSYoyhtFh+sk95hTNpg9AK/mdnXKz3hy/nqSbSTQ=";
  		};
		});
	})];

  users.users.stereomato.packages = with pkgs; [
		# TODO: Organize better

			# Virt
			virt-manager

			# Cryptocurrency
			monero-gui xmrig-mo

			# File compressors
			rar p7zip

			# Miscellanous cli apps
			xorg.xeyes maigret bc xdg-utils trash-cli

			# Phone stuff
			scrcpy
			
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers
			
		]
		++ lib.optionals config.services.desktopManager.plasma6.enable [
			# QT LO
			libreoffice-qt-fresh
		 ]
		++ lib.optionals config.services.xserver.desktopManager.gnome.enable [
			# Normal LO
			libreoffice-fresh

			# Extra Gnome Circle apps
			metadata-cleaner warp wike gnome-solanum newsflash gtg gnome-graphs

			# Font management
			fontforge-gtk

			# AI
			alpaca
		 ];

}

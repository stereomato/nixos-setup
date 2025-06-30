{pkgs, ...}:{
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

			# Cryptocurrency
			monero-gui xmrig-mo

			# File compressors
			rar p7zip

			# Miscellanous cli apps
			xorg.xeyes bc xdg-utils trash-cli

			# Phone stuff
			scrcpy
			
			# Spellchecking dictionaries
			#TODO: Write about this in the future NixOS article I wanna write.
			hunspellDicts.en_US hunspellDicts.es_PE aspellDicts.en aspellDicts.es aspellDicts.en-science aspellDicts.en-computers
			
	];
}

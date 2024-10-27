{ ... }:{
	

	programs = {
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		};
		adb.enable = true;
		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;

		# KDE stuffs
		kdeconnect.enable = true;
		partition-manager.enable = true;
		kde-pim = {
			merkuro = true;
			kontact = true;
			kmail = true;
		};
		# https://github.com/NixOS/nixpkgs/issues/348919
		# k3b.enable = true;
	};
}
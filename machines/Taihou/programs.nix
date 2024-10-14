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
	};
}
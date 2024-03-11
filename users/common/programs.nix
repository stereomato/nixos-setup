{ ... }:{
	

	programs = {
		mtr.enable = true;
		fish = {
			enable = true; 
			useBabelfish = true;
		};
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		};
		adb.enable = true;
		usbtop.enable = true;
		atop = {
			enable = true;
			setuidWrapper.enable = true;
			atopService.enable = true;
			atopacctService.enable = true;
			# Nah, only supports Nvidia. #intelFTW
			#atopgpu.enable = true;
			netatop.enable = false;
		};

		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;
	};
}
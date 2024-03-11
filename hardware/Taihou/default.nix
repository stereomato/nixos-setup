{ ... }: {
	# Just imports basically
	imports = [
		./boot.nix
		./kernel.nix
		./filesystems.nix
		./security.nix
	];
	
	networking.hostName = "Taihou";

	time = {
		timeZone = "America/Lima";
	};

	services = {
		xserver = {
			# Keyboard layout
			xkb.layout = "latam";
		};
		
		udev.extraRules = ''
			KERNEL=="cpu_dma_latency", GROUP="audio"
			KERNEL=="rtc0", GROUP="audio"
			KERNEL=="hpet", GROUP="audio"
		'';
	};



}
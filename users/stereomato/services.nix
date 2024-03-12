{ ... }:{
  services = {
		home-manager = {
			autoUpgrade = {
				enable = false;
				frequency = "friday";
			};
		};
		easyeffects = {
			enable = true;
		};
		
		syncthing = {
			enable = true;
		};
		
		#home-manager-gc.enable = true;
	};
}
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
		lorri = {
			enable = true;
			enableNotifications = true;
			# There's also package and nixPackage.
		};
		syncthing = {
			enable = true;
		};
		gpg-agent = {
			enable = true;
			enableSshSupport = true;
		};
	};
}
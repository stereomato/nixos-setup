{ taihouConfig, pkgs, username, ... }:{
  # Here goes everything related to software development
	
  services = {
    lorri = {
			enable = true;
			enableNotifications = true;
			# There's also package and nixPackage.
		};

    gpg-agent = {
			enable = true;
			enableSshSupport = true;
			pinentryPackage = if taihouConfig.services.desktopManager.plasma6.enable then pkgs.pinentry-qt else pkgs.pinentry-gnome3;
		};
  };

  programs = {
		direnv = {
			enable = true;
			# Fish integration is always enabled
			#enableFishIntegration = true;
			enableBashIntegration = true;
			nix-direnv.enable = true;
		};
    gpg = {
			enable = true;
			# mutableKeys and mutableTrust are enabled by default

		};
		git = {
			enable = true;
			package = pkgs.gitFull;
			userName = "${username}";
			userEmail = "stereomato@proton.me";
			delta = {
				enable = true;
			};
			lfs = {
				enable = true;
			};
			signing = {
				signByDefault = true;
				key = "A7C49F67B6D0A76F";
			};

		};
		gh = {
			enable = true;
		};
  };
}

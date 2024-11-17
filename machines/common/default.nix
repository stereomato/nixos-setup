{ pkgs, ... }:{
	imports = [
		./desktop-environment.nix
		./fonts.nix
		./hardware.nix
		./i18n.nix
		./networking.nix
		./nix.nix
		./performance.nix
		./system-management.nix
		./system.nix
		./toolkits.nix
		./users.nix
		./virtualisation.nix
	];

	# In this place goes things that are too general or too small that putting them in their own files is just cluttering

	console = {
		font = "Lat2-Terminus16";
	};

	documentation = {
		man = {
			generateCaches = true;
			mandoc = {
				enable = false;
			};
			man-db = {
				enable = true;
			};
		};
		dev = {
			enable = true;
		};
	};
	
	environment = {
			
			etc."current-nixos".source = ./.;

			variables = {
			EDITOR = "nano";
		};
	};

		# Firefox
		programs.firefox = {
			enable = true;
		};
		
		# GPS
		location.provider = "geoclue2";
		services.geoclue2 = {
			enable = true;
			# Because MLS is ded, BeaconDB can now be used.
			# TODO: See how can I help with BeaconDB.
			# Maybe api.beacondb.net shouldn't be used here, but instead just beacondb.net?
			# Also see https://github.com/NixOS/nixpkgs/issues/321121
			# https://github.com/NixOS/nixpkgs/pull/325430
			geoProviderUrl = "https://beacondb.net/v1/geolocate";
			submissionUrl = "https://beacondb.net/v2/geosubmit";
			submissionNick = "stereomato";
			submitData = true;
		};
	security = {
		protectKernelImage = true;
		
		sudo = {
			enable = true;
		};
		
		polkit.enable = true;
	};
}

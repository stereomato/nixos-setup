{ pkgs, ... }:{
	imports = [
		./boot.nix
		# ./desktop-environment.nix
		./fonts.nix
		./software.nix
		./hardware.nix
		# ./i18n.nix
		#./networking.nix
		#./nix.nix
		# ./performance.nix
		./system-management.nix
		#./system.nix
		./toolkits.nix
		# ./virtualisation.nix
	];

	# In this place goes things that are too general or too small that putting them in their own files is just cluttering

	#TODO: consider putting high level toggles here?
	# Like, stuff like the toggle for enabling kde or gnome, so that I can put better shaped conditionals on desktop-environment.nix
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

		
}

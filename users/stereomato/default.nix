{ lib, pkgs, ... }:{
	imports = [
		./imports
		./media
		./pkgs
		./software-development

		./envvars.nix
		./fish.nix
		./workarounds.nix
		
	];


	fonts = {
		fontconfig = {
			enable = true;
		};
	};

	# Home-manager
	home = {
		username = "stereomato";
		homeDirectory = lib.mkDefault "/home/stereomato";
	};
	programs.home-manager.enable = true;
	# Home-manager version
	# Update notes talk about it
	home.stateVersion = "23.11";

	# man pages
	programs.man = {
			enable = true;
			# FIXME: https://github.com/nix-community/home-manager/issues/4624
			# package = pkgs.mandoc;
			generateCaches = true;
		};
		
	# For Minecraft really.
	programs.java = {
		enable = true;
		package = pkgs.jdk17;
	};
	
	# nix-index is a tool that gives you a thing like c-n-f but somewhat better.
	programs.nix-index = {
			enable = true;
	};

	# nix-index conflicts with this, so let's disable it.
	programs.command-not-found.enable = false;

	# Enable cache for the nixified-ai flake.
	nix = {
		settings = {
			substituters = [
				# nixpkgs
				"https://cache.nixos.org"
				# nixified-ai
				"https://ai.cachix.org"
			];
		};
	};

}
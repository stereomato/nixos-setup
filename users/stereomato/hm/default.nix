{ taihouConfig, lib, pkgs, ... }:{
	imports = [
		./software-development
		./envvars.nix
		./fish.nix
		./deskEnv-config.nix
		./workarounds.nix
		./mpv.nix
	];

	# TODO: Need to fix this on the non-module hm config
	# nix.package = pkgs.nix;

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
	home.stateVersion = "24.11";

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

	# nixpkgs = {
	# 	config = {
	# 		allowUnfree = true;
	# 		permittedInsecurePackages = [
	# 				"olm-3.2.16"
	# 				# FIXME: https://github.com/NixOS/nixpkgs/issues/269713
	# 				"openssl-1.1.1w"
	# 				# FIXME: https://github.com/NixOS/nixpkgs/pull/280835
	# 				"freeimage-unstable-2021-11-01"
	# 		];
	# 	};
	# 	overlays = [(
	# 		self: super: {
	# 			vscode = super.vscode.override {
	# 				commandLineArgs = "--disable-font-subpixel-positioning=true";
	# 			};
	# 		})];
	# };

	services.syncthing = {
		enable = true;
	};

	# QT look on gnome
	qt = {
		enable = taihouConfig.services.xserver.desktopManager.gnome.enable;
		platformTheme.name = "adwaita";
	};

	programs.yt-dlp = {
		enable = true;
		settings = {
			# No color output
			#--no-colors;
			# Set aria2 as downloader
			downloader = "aria2c";
			# aria2 arguments
			downloader-args = "aria2c:'-x 10'";
		};
	};
}

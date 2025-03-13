{ inputs, taihouConfig, config, lib, pkgs, ... }:{
	imports = [
		./software-development
		./envvars.nix
		./fish.nix
		./deskEnv-config.nix
		./workarounds.nix
		./mpv.nix
		#TODO: I might have to fix this when using home manager as standalone
		inputs.nix-index-database.hmModules.nix-index

	];

	# This checks if the non-module home-manager is being used
	# Might be undeeded, but keep it just in case
	# nix.package = lib.mkIf (!config ? home-manager.users) pkgs.nix;

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

	services.syncthing = {
		enable = true;
	};

	# QT look on gnome
	qt = {} // lib.mkIf (taihouConfig.services.xserver.desktopManager.gnome.enable) {
		enable = true;
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

	systemd.user = {
		enable = true;
		services = {
			ollama-intel-gpu = {
				Service = {
					ExecStart = "/run/current-system/sw/bin/podman run --rm -p 127.0.0.1:11434:11434 -v /home/stereomato/models:/mnt -v ollama-volume:/root/.ollama -e OLLAMA_MAX_LOADED_MODELS=1 -e OLLAMA_FLASH_ATTENTION=1 -e OLLAMA_NUM_GPU=999 -e DEVICE=iGPU --device /dev/dri --name=ollama-intel-gpu localhost/ollama-intel-gpu:latest";
					ExecStop = "/run/current-system/sw/bin/podman stop ollama-intel-gpu";
					Restart = "never";
				};
			Install = {
				WantedBy = [ "graphical-session.target" ];
			};
			};
		};
	};
}

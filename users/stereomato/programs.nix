{ pkgs, username, ... }:{
  imports = [
		./imports/vscode.nix
		./imports/mpv.nix
		./imports/fish.nix
	];
	
	programs = {
		home-manager = {
			enable = true;
		};
		firefox = {
			enable =  true;
		};
		
		direnv = {
			enable = true;
			# Fish integration is always enabled
			#enableFishIntegration = true;
			enableBashIntegration = true;
			nix-direnv.enable = true;
		};
		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;
		micro = {
			enable = true;
			# See this page for configuration settings
			# https://github.com/zyedidia/micro/blob/master/runtime/help/options.md
			settings = {};
		};
		java = {
			enable = true;
			package = pkgs.jdk17;
		};
		gpg = {
			enable = true;
			# mutableKeys and mutableTrust are enabled by default
		};
		git = {
			enable = true;
			package = pkgs.gitFull;
			userName = "${username}";
			userEmail = "thepearsche@proton.me";
			delta = {
				enable = true;
			};
			lfs = {
				enable = true;
			};
			signing = {
				signByDefault = true;
				key = "AEC0A812DBBE4BC9";
			};

		};
		gh = {
			enable = true;
		};
		# Both the settings for btop, htop and mangohud have been removed as they are programs that
		# update their own settings at runtime thus making them unsuitable for this kind of configuration
		# Instead, their configuration folders are kept in this repo at ./to-symlink/ and
		# are symlinked by h-m
		btop = {
			enable = true;
		};
		htop = {
			enable = true;
		};
		
		
		yt-dlp = {
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
		man = {
			# TODO: https://github.com/nix-community/home-manager/issues/4624
			# package = pkgs.mandoc;
			generateCaches = true;
		};
		mangohud = {
			enable = true;
		};
		nix-index = {
			enable = true;
		};
		
		###
		
	};

}
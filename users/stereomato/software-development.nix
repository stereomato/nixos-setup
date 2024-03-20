{ pkgs, username, ... }:{
  # Here goes everything related to software development 
  imports = [
    ./imports/vscode.nix
  ];

  home.packages = with pkgs; [
    # Requires nixos/nixpkgs newer than 22.11
		toolbox distrobox
		# Computer Graphics
		blender

		# Compilers, configurers
		patchelf

		# Terminals
		blackbox-terminal

		# Nix tooling
		# FIXME: nixd https://github.com/nix-community/nixd/issues/357
		nix-prefetch-scripts niv nil

		# Debuggers
		gdb valgrind

		# Code editors/IDEs
		netbeans micro 

		# Documentation tools
		zeal
		
		# Java libraries
		commonsIo
		
		# Gamedev
		unityhub godot3-mono godot3-mono-export-templates
		## This is for godot's C# support
		msbuild
  ];
  
  services = {
    lorri = {
			enable = true;
			enableNotifications = true;
			# There's also package and nixPackage.
		};

    gpg-agent = {
			enable = true;
			enableSshSupport = true;
			pinentryPackage = pkgs.pinentry-gnome3;
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
  };
}
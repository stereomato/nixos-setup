{ pkgs, username, ... }:{
  # Here goes everything related to software development 
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    # Requires nixos/nixpkgs newer than 22.11
		toolbox distrobox
		# Computer Graphics
		blender

		# Compilers, configurers
		patchelf

		# Terminals
		# blackbox-terminal

		# Nix tooling
		nixd
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

		# Arduino
		arduino-ide
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

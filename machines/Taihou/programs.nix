{ ... }:{
	nixpkgs.overlays = [(
		self: super: {
			steam = super.steam.override {
				extraPkgs = pkgs: with pkgs; [
					openssl_1_1
					curl
					libssh2
					openal
					zlib
					libpng
					# https://github.com/NixOS/nixpkgs/issues/236561
					attr
					xorg.libXcursor
					xorg.libXi
					xorg.libXinerama
					xorg.libXScrnSaver
					libpng
					libpulseaudio
					libvorbis
					stdenv.cc.cc.lib
					libkrb5
					keyutils
				];
			};
		}
	)];

	programs = {
		steam = {
			enable = true;
			remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
			dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		};
		adb.enable = true;
		# nix-index conflicts with this, so let's disable it.
		command-not-found.enable = false;
	};
}

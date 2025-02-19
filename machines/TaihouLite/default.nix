	{ modulesPath, inputs, lib, pkgs, ... }: {
		# Just imports basically
		imports = [
			"${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"

			../Taihou
		];



		networking.hostName = lib.mkForce "TaihouLite";

		localModule.gnome.minimal.enable = lib.mkForce true;
	}

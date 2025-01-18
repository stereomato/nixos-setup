	{ modulesPath, inputs, pkgs, ... }: {
		# Just imports basically
		imports = [
			"${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
		];

		networking.hostName = "TaihouLite";
	}

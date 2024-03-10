{ ... }: {
	# Just imports basically
	imports = [
		./common
		./boot.nix
		./kernel.nix
		./filesystems.nix
		./security.nix
	];
	
	networking.hostName = "Taihou";
}
{ ... }:{
	# https://pagure.io/fedora-workstation/issue/351
	# https://github.com/NixOS/nixpkgs/commit/622745942bc7b7cc056bfbb0bc6004dd823fa4f5
	#home-manager.users.stereoamto.qt = {
	#	enable = true;
	#	platformTheme = "gnome";
	#	style = {
	#		name = "adwaita";
	#	};
	#};

	qt = {
		# There's no need to enable this, the nixos gnome integration already does so.
		#enable = true;
		#style = "adwaita";
		#platformTheme = "gnome";
	};
}

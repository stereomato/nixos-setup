{ pkgs, lib, ... }:

{

	home = {
		username = "stereomato";
		homeDirectory = lib.mkDefault "/home/stereomato";
		
		
		# Broken https://github.com/nix-community/home-manager/issues/3417
		# environment.localBinInPath for configuration.nix exists anyway.
		#sessionPath = [
		#	"$HOME/.local/bin"
		#];
		
		file."current-hm".source = ./.;
		
	
		# Version that the installed home-manager is compatible with.
    # Update notes talk about it.
		stateVersion = "23.11";


	# Workaround for cursors broken in gnome by default
	# affects: mpv and games it seems
		pointerCursor = {
			package = pkgs.gnome.adwaita-icon-theme;
			name = "Adwaita";
			size = 24;
			gtk.enable = true;
			x11.enable = true;
		};

	};
}

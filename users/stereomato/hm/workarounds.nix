{ taihouConfig, config, installPath, lib, pkgs, ...  }: {
	home = {
		# FIXME: https://www.reddit.com/r/NixOS/comments/vh2kf7/home_manager_mkoutofstoresymlink_issues/
		# Workaround: Symlink configuration files for programs that modify their settings at runtime/exit
		# https://github.com/nix-community/issues/3514
		# FIXME: Some of these configurations can be handled better, so, do that
		file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/btop";
		file.".config/htop".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/htop";
		file.".config/easyeffects".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/easyeffects";
		file.".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/neofetch";
		file.".config/xmrig-mo".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/xmrig-mo";
		file.".config/MangoHud".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/users/stereomato/hm/to-symlink/MangoHud";
	
	# Workaround: for cursors broken in gnome by default
	# affects: mpv and games it seems
	# This might be uneeded when gtk 4.18 drops
		 pointerCursor = lib.mkIf taihouConfig.services.desktopManager.gnome.enable {
		 	package = pkgs.adwaita-icon-theme;
		 	name = "Adwaita";
		 	# Set to 12 because of mpv
		 	# TODO: does this affect other stuff?
		 	size = 24;
			# Makes the GNOME cursor tiny
		 	gtk.enable = false;
			# I only really need this, I think?
		 	x11.enable = true;
		 }  ;
	};
}

{ config, installPath, ...  }: {
	home = {
		# FIXME: https://www.reddit.com/r/NixOS/comments/vh2kf7/home_manager_mkoutofstoresymlink_issues/
		# Symlink configuration files for programs that modify their settings at runtime/exit
		# https://github.com/nix-community/home-manager/issues/3514
		# FIXME: Some of these configurations can be handled better, so, do that.
		#file.".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/btop";
		file.".config/htop".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/htop";
		file.".config/easyeffects".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/easyeffects";
		file.".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/neofetch";
		file.".config/xmrig-mo".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/xmrig-mo";
		file.".config/MangoHud".source = config.lib.file.mkOutOfStoreSymlink "${installPath}/modules/home-manager/to-symlink/MangoHud";
	};

}
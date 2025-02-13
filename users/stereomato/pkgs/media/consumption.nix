{ config, pkgs, ... }:{
	# Here go things that are related to media consumption
	imports = [
	];

	users.users.stereomato.packages = with pkgs; [
		# anime
		ani-cli
		
		# Music
		spotify

		# Video
		syncplay open-in-mpv

		# Gstreamer programs
		gst_all_1.gstreamer

		# Downloader
		popcorntime

		# Streamer
		stremio

	] ++ lib.optionals config.services.desktopManager.plasma6.enable [ 
			# Video players/MPV Frontends
			haruna 

			# Audio players
			fooyin
		]
	++ lib.optionals config.services.xserver.desktopManager.gnome.enable [
			# Digital books (epubs, manga)
			foliate
			# Digital media players/readers/streamers/frontends
			# FTBFS: nix log /nix/store/ia6nr3xzzvqpjm4c5c30pnvar1dma6cs-quodlibet-4.6.0.drv
			amberol gthumb# celluloid
	];
}

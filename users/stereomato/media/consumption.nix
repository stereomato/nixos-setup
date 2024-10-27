{ pkgs, ... }:{
	# Here go things that are related to media consumption
	imports = [
		./mpv.nix
	];

	home.packages = with pkgs; [
		# anime
		ani-cli

		# Digital media players/readers/streamers
		# FTBFS: nix log /nix/store/ia6nr3xzzvqpjm4c5c30pnvar1dma6cs-quodlibet-4.6.0.drv
		#celluloid clapper amberol rhythmbox  gthumb

		# Music
		spotify

		# Video
		syncplay open-in-mpv

		# Gstreamer programs
		gst_all_1.gstreamer
		# Digital books (epubs, manga)
		# foliate
	];

	programs.yt-dlp = {
		enable = true;
		settings = {
			# No color output
			#--no-colors;
			# Set aria2 as downloader
			downloader = "aria2c";
			# aria2 arguments
			downloader-args = "aria2c:'-x 10'";
		};
	};

	services = {
		easyeffects = {
			enable = true;
		};
	};

}

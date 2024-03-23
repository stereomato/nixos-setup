{ pkgs, ... }:{
	# Here go things that are related to media consumption
	imports = [
		./mpv.nix
	];

	home.packages = with pkgs; [
		# Digital media players/readers/streamers
		celluloid clapper amberol quodlibet rhythmbox spotify gthumb syncplay open-in-mpv
		# Gstreamer programs
		gst_all_1.gstreamer
		# Digital books (epubs, manga)
		foliate

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

}
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


}
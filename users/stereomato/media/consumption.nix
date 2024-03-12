{ pkgs, ... }:{
  # Here go things that are related to media consumption
  imports = [
    ./mpv.nix
  ];

  home.packages = with pkgs; [
    # Digital media players/readers/streamers
		celluloid clapper amberol quodlibet rhythmbox spotify gthumb syncplay
  ];


}
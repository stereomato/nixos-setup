{ pkgs, ... }:{
  home.packages = with pkgs; [
    # Web Browsers
    google-chrome vivaldi vivaldi-ffmpeg-codecs 
    
    # Ask for it to be fixed someday
    #vivaldi-widevine 

    # Chat apps
    tdesktop discord gnome.polari mumble fractal element-desktop dino

    # Password management
		bitwarden bitwarden-cli

    # Internet tools
	  curl wget aria fragments megacmd
    # VPN
		protonvpn-gui
  ];
}
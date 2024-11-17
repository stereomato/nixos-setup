{ pkgs, ... }:{

  nixpkgs.config = {

    # Doesn't work due to https://github.com/nix-community/home-manager/issues/6015
    #permittedInsecurePackages = [
      # Neochat
     # "olm-3.2.16"
    #];

    
  };

  home.packages = with pkgs; [
    # Web Browsers
    google-chrome vivaldi vivaldi-ffmpeg-codecs 
    
    # Ask for it to be fixed someday
    #vivaldi-widevine 

    # Chat apps
    # Matrix
     fractal
    #kdePackages.neochat

    # XMPP
    #kaidan

    # Et cetera
    tdesktop discord mumble element-desktop

    # Password management
    bitwarden bitwarden-cli

    # Internet tools
    fragments

    # Downloaders
    curl wget aria megacmd
    #kget

    # VPN
    protonvpn-gui

    # Virtual classes
    zoom-us
  ];

  services.syncthing = {
		enable = true;
	};
}

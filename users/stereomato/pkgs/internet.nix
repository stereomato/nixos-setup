{pkgs, ... }:{
	users.users.stereomato.packages = with pkgs; [
		# Web Browsers
		google-chrome

		# Chat/Voice Chat apps
		tdesktop discord mumble element-desktop

		# Password management
		bitwarden 

		# Downloaders
		curl wget aria megacmd

		# VPN
		# protonvpn-gui

		# Virtual classes
		zoom-us
	];
}

{ taihouConfig, pkgs, lib, ... }: {
  programs.gnome-shell = {
		enable = taihouConfig.services.xserver.desktopManager.gnome.enable;
		extensions = [
			# Alphabetical App Grid
			{ package = pkgs.gnomeExtensions.alphabetical-app-grid; }
			# System Monitor
			{
				id = "system-monitor@gnome-shell-extensions.gcampax.github.com";
				package = pkgs.gnome-shell-extensions;
			}
			# GTK3 Themes
			# For adw-gtk3
			{
				id = "user-theme@gnome-shell-extensions.gcampax.github.com";
				package = pkgs.gnome-shell-extensions;
			}
		]
		;
	};

	# TODO: Make this work on KDE only
	#xresources.properties ={
	#	"Xft.rgba" = "rgb";
	#	"Xft.lcdfilter" = "lcddefault";
	#};

	home.packages = if taihouConfig.services.xserver.desktopManager.gnome.enable then with pkgs; [
		# Workaround for gtk.theme.package
		adw-gtk3
	] else [];
	
	# TODO: does this break anything in KDE?
	# Probably not
	gtk = {
		enable = taihouConfig.services.xserver.desktopManager.gnome.enable;
		theme = {
			name = "adw-gtk3";
			# package = pkgs.adw-gtk3;
		};
		iconTheme = {
			name = "MoreWaita";
			package = pkgs.morewaita-icon-theme;
		};
	};

	# TODO: does this break anything in KDE?
	# Probably not
	dconf = {
		enable = taihouConfig.services.xserver.desktopManager.gnome.enable;
		settings = {
			"org/gnome/desktop/peripherals/mouse" = {
				speed = lib.hm.gvariant.mkDouble "-0.75";
			};
			"org/gnome/shell" = {
				favorite-apps = lib.hm.gvariant.mkArray lib.hm.gvariant.type.string [
					"google-chrome.desktop"
					"org.gnome.Console.desktop"
					"org.gnome.Nautilus.desktop"
					"code.desktop"
				];
			};
			"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
				binding = "<Control><Alt>ntilde";
				command = "env TERM=xterm-256color fish -c 'dmmm-mouse-fix'";
				name = "DMMM mouse fix";
			};
			"org/gnome/settings-daemon/plugins/media-keys" = {
				custom-keybindings = lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
			};
			"org/gnome/desktop/search-providers" = {
				enabled = "org.gnome.Weather.desktop";
			};
			"org/gnome/shell/app-switcher" = {
				current-workspace-only = true;
			};
			"org/gnome/settings-daemon/plugins/power" = {
				sleep-inactive-ac-type = "nothing";
			};
			"org/gnome/shell/weather" = {
				automatic-location = true;
			};
			"org/gnome/system/location" = {
				enabled = true;
			};
			"org/gnome/desktop/wm/preferences" = {
				button-layout = "close:appmenu";
			};
			"org/gnome/desktop/datetime" = {
				automatic-timezone = true;
			};
			"org/gnome/desktop/interface" = {
				# icon-theme = "MoreWaita";
				font-name = "System-ui 10";
				document-font-name = "Serif 10";
				monospace-font-name = "Monospace 10";
				font-hinting = "none";
			};
		};
	};

}
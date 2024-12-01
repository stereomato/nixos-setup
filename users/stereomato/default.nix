{ lib, pkgs, ... }:{
	imports = [
		./imports
		./media
		./pkgs
		./software-development

		./envvars.nix
		./fish.nix
		./workarounds.nix

	];

	nix.package = pkgs.nix;

	fonts = {
		fontconfig = {
			enable = true;
		};
	};

	# Home-manager
	home = {
		username = "stereomato";
		homeDirectory = lib.mkDefault "/home/stereomato";
	};
	programs.home-manager.enable = true;
	# Home-manager version
	# Update notes talk about it
	home.stateVersion = "24.11";

	# man pages
	programs.man = {
			enable = true;
			# FIXME: https://github.com/nix-community/home-manager/issues/4624
			# package = pkgs.mandoc;
			generateCaches = true;
		};

	# For Minecraft really.
	programs.java = {
		enable = true;
		package = pkgs.jdk17;
	};

	# nix-index is a tool that gives you a thing like c-n-f but somewhat better.
	programs.nix-index = {
			enable = true;
	};

	# nix-index conflicts with this, so let's disable it.
	programs.command-not-found.enable = false;

	# Enable cache for the nixified-ai flake.
	nix = {
		settings = {
			substituters = [
				# nixpkgs
				"https://cache.nixos.org"
				# nixified-ai
				"https://ai.cachix.org"
			];
		};
	};

	nixpkgs = {
		config = {
			allowUnfree = true;
			permittedInsecurePackages = [
					"olm-3.2.16"
					# FIXME: https://github.com/NixOS/nixpkgs/issues/269713
					"openssl-1.1.1w"
					# FIXME: https://github.com/NixOS/nixpkgs/pull/280835
					"freeimage-unstable-2021-11-01"
			];
		};
	};

	# QT look on gnome
	qt = {
		enable = true;
		platformTheme.name = "adwaita";
	};

	systemd.user.sessionVariables = {
		# https://github.com/NixOS/nixpkgs/issues/53631
			# Fixes Kooha, Clapper
			GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
				pkgs.gst_all_1.gstreamer.out
				pkgs.gst_all_1.gst-plugins-base
				pkgs.gst_all_1.gst-plugins-good
				pkgs.gst_all_1.gst-plugins-bad
				pkgs.gst_all_1.gst-plugins-ugly
				pkgs.gst_all_1.gst-libav
				pkgs.gst_all_1.gst-vaapi
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-base
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-good
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-bad
				pkgs.pkgsi686Linux.gst_all_1.gst-plugins-ugly
				pkgs.pkgsi686Linux.gst_all_1.gst-vaapi
				pkgs.pkgsi686Linux.gst_all_1.gst-libav
			];
	};

	programs.gnome-shell = {
		enable = true;
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

	home.packages = with pkgs;[
		# Workaround for gtk.theme.package
		adw-gtk3
	];

	gtk = {
		enable = true;
		theme = {
			name = "adw-gtk3";
			# package = pkgs.adw-gtk3;
		};
		iconTheme = {
			name = "MoreWaita";
			package = pkgs.morewaita-icon-theme;
		};
	};

	dconf = {
		enable = true;
		settings = {
			"org/gnome/desktop/peripherals/mouse" = {
				speed = lib.hm.gvariant.mkDouble "-0.72093023255813948";
			};

			"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
				binding = "<Control><Alt>ntilde";
				command = "env TERM=xterm-256color fish -c 'dmmm-mouse-fix'";
				name = "DMMM mouse fix";
			};
			"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" = {
				custom0 = lib.hm.gvariant.mkArray lib.hm.gvariant.type.string ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
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

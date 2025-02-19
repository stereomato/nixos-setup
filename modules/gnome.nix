{inputs, config, lib, pkgs, ...}:
	let cfg = config.localModule;
	in
	{
		options.localModule = {
			gnome.enable = lib.mkEnableOption "the GNOME desktop environment";
			gnome.minimal.enable = lib.mkEnableOption "a minimal GNOME setup.";
			#plasma.enable = lib.mkEnableOption "Enable the KDE Plasma desktop environment";
			#minimal.enable = lib.mkEnableOption "Build a minimal system, for like a live environment";
		};

		config = lib.mkIf (cfg.gnome.enable) {
			services= {
				xserver.desktopManager.gnome = {
					enable = true;
					extraGSettingsOverridePackages = [ pkgs.mutter ];
					# There's a possible extra setting I could add here, but I don't know if it's necessary considering I modify font settings using fontconfing: https://www.reddit.com/r/gnome/comments/1grtn97/comment/lx9fiib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
					# Removed 'xwayland-native-scaling' because it's annoying how it's implemented in Gnome, and I don't
					# give enough of a shit about blurry Xwayland apps honestly. Most end up working on wayland eventually
					extraGSettingsOverrides = ''
						[org.gnome.mutter]
						experimental-features=['scale-monitor-framebuffer']
					'';
				};
				# The Gnome Display Manager
				xserver.displayManager.gdm.enable = true;
				# Extra gnome apps
				gnome = {
					core-developer-tools.enable = true;
					# I don't need this, lmao
					games.enable = false;
				};
			};

			programs = {
				# TODO: ask why these 2 and gnome-power-manager aren't in any of the 3 gnome toggles.
				# TODO: https://github.com/NixOS/nixpkgs/pull/368610/commits/8c17fbe4656087e9a86a573b5a0d76e939225f21
				calls.enable = false;
				# There's no "Open in Ptyxis" element in the right click menu of Files so... add it
				# Ptyxis has to be installed.
				nautilus-open-any-terminal = {
					enable = true;
					terminal = "ptyxis";
				};
			};

			environment = {
				gnome.excludePackages = with pkgs; [ 
				];
				systemPackages = with pkgs; [
					# Default PDF viewer
					papers
					# Miscellanous Gnome apps
					gnome-icon-theme gnome-tweaks # gnome-extension-manager
					ptyxis
					gnome-boxes
					showtime
					morewaita-icon-theme
					mission-center
					resources
					gnome-power-manager
					# This is needed for file-roller to open .debs
					binutils
				] ++ lib.optionals (! cfg.gnome.minimal.enable) [
					# Normal LO
					libreoffice-fresh

					# Extra Gnome Circle apps
					metadata-cleaner warp wike gnome-solanum newsflash gtg gnome-graphs

					# Font management
					fontforge-gtk

					# AI
					alpaca

					# Chat apps
					fractal
					
					# Downloaders
					fragments

					# Digital books (epubs, manga)
					foliate
					# Digital media players/readers/streamers/frontends
					# FTBFS: nix log /nix/store/ia6nr3xzzvqpjm4c5c30pnvar1dma6cs-quodlibet-4.6.0.drv
					amberol gthumb# celluloid

					# Images
					drawing gnome-obfuscate eyedropper
					# Video
					kooha
				];
			};

			nixpkgs.overlays = [(
				self: super: {
					# Dynamic triple buffering patch
					# Bugged currently
					mutter = super.mutter.overrideAttrs (old: {
							src = inputs.mutter-triple-buffering-src;
							preConfigure = ''
								cp -a "${inputs.gvdb-src}" ./subprojects/gvdb
							'';
					});

					wike = super.callPackage ./wike.nix {};
				}
			)];

			system.replaceDependencies.replacements = [
				# Disable stem darkening on QT
				{
					oldDependency = pkgs.kdePackages.qtbase;
					newDependency = pkgs.kdePackages.qtbase.overrideAttrs(old: {
						patches = pkgs.kdePackages.qtbase.patches ++ [
							./patches/disable-stem-darkening.patch
						];
					});
				}
				{
					oldDependency = pkgs.libsForQt5.qt5.qtbase;
					newDependency = pkgs.libsForQt5.qt5.qtbase.overrideAttrs(old: {
						patches = pkgs.libsForQt5.qt5.qtbase.patches ++ [
							./patches/disable-stem-darkening-qt5.patch
						];
					});
				}
			];
		};
	}

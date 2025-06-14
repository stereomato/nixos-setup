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
				desktopManager.gnome = {
					enable = true;
					extraGSettingsOverridePackages = [ pkgs.mutter ];
					# There's a possible extra setting I could add here, but I don't know if it's necessary considering I modify font settings using fontconfing: https://www.reddit.com/r/gnome/comments/1grtn97/comment/lx9fiib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
					# Removed 'xwayland-native-scaling' because it's annoying how it's implemented in Gnome, and I don't
					# give enough of a shit about blurry Xwayland apps honestly. Most end up working on wayland eventually
					extraGSettingsOverrides = ''
						[org.gnome.mutter]
						experimental-features=['scale-monitor-framebuffer' ]
					'';
				};
				# The Gnome Display Manager
				displayManager.gdm.enable = true;
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
					# gdctl
					mutter
					# Default PDF viewer
					papers
					# Miscellanous Gnome apps
					gnome-icon-theme gnome-tweaks
					ptyxis
					gnome-boxes
					showtime
					morewaita-icon-theme
					mission-center
					resources
					gnome-power-manager
					# This is needed for file-roller to open .debs
					binutils

					ghostty

					# Normal LO
					libreoffice-fresh
				] ++ lib.optionals (! cfg.gnome.minimal.enable) [
					
					# Fedi
					tuba
					
					# Extra Gnome Circle apps
					metadata-cleaner warp wike gnome-solanum newsflash gtg gnome-graphs

					# Font management
					fontforge-gtk

					# AI
					alpaca

					# Chat apps
					fractal dino
					
					# Downloaders
					fragments

					# Digital books (epubs, manga)
					foliate

					# Digital media players/readers/streamers/frontends
					g4music gthumb# celluloid

					# Images
					pinta gnome-obfuscate eyedropper # upscaler
					
					# Video
					# pitivi
				];
			};

			nixpkgs.overlays = [(
				self: super: {
					zoom-us = super.zoom-us.override {
						gnomeXdgDesktopPortalSupport = true;
					};
					start-ollama-on-demand-fish = pkgs.writers.writeFishBin "start-ollama-on-demand" ''
						# Need to write a script that starts ollama-intel-gpu, waits until it's finished
						# And then starts alpaca.
						# When alpaca is closed, the script stops ollama-intel-gpu

						systemctl start --user ollama-intel-gpu.service

						# TODO: Need to figure out how to properly detect that ollama is already listening
						sleep 5

						alpaca

						systemctl stop --user ollama-intel-gpu.service
					''; 

					wike = super.callPackage ./wike.nix {};

					# TODO: until https://github.com/ollama/ollama/pull/8072 is fixed
					# alpaca = super.alpaca.overrideAttrs (old: {
					# 	postInstall = ''
					# 		substituteInPlace $out/share/applications/com.jeffser.Alpaca.desktop --replace-fail Exec=alpaca Exec=${pkgs.start-ollama-on-demand-fish}/bin/start-ollama-on-demand
					# 	'';
					# });
				}
			)];
		};
	}

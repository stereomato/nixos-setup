{config, lib, pkgs, ...}:
	let cfg = config.localModule;
	in
	{
		options.localModule = {
			plasma.enable = lib.mkEnableOption "the KDE Plasma desktop environment";
			plasma.minimal.enable = lib.mkEnableOption "a minimal KDE Plasma installation";
		};

		config = lib.mkIf cfg.plasma.enable {
			services = {
				desktopManager.plasma6.enable = true;
				colord.enable = true;
				displayManager.sddm = {
					enable = true;
					wayland.enable = true;
				};
			};
			
			programs = {
				kdeconnect.enable = true;
					partition-manager.enable = true;
					kde-pim = {
						merkuro = true;
						kontact = true;
						kmail = true;
					};
					# https://github.com/NixOS/nixpkgs/issues/348919
					# k3b.enable = true;
			};

			environment = {
				systemPackages = with pkgs; [
					#  Extra KDE stuff
					kdePackages.filelight
					kdePackages.qtsvg
					kdePackages.kleopatra
					bibata-cursors
					kdePackages.kdevelop
				] ++ lib.optionals (! cfg.plasma.minimal.enable) [
					# Sound
					kid3-kde

					# Video players/MPV Frontends
					haruna vlc

					# Audio players
					# FTBFS https://github.com/NixOS/nixpkgs/issues/399801
					# fooyin

					# Chat Apps
					kdePackages.neochat nheko kaidan zapzap
			
					# Downloaders
					kdePackages.kget

					# Web browser
					kdePackages.falkon # kdePackages.angelfish

					# QT LO
					libreoffice-qt-fresh

					# AI
					kdePackages.alpaka

					# Video Production
					kdePackages.kdenlive

					# Extras
					kdePackages.yakuake

					# Images
					krita


				];
				sessionVariables = {
					# System wide stem darkening
					# Testing: Inconsistent in plasma/QT
					# FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";

					
				};
			};
			# system.replaceDependencies.replacements = [
			# 	# https://bugs.kde.org/show_bug.cgi?id=479891#c114
			# 	{
			# 		oldDependency = pkgs.kdePackages.qqc2-desktop-style;
			# 		newDependency = pkgs.kdePackages.qqc2-desktop-style.overrideAttrs (old: {
			# 			# Doesn't have a patches attribute
			# 			patches = [ ./patches/qqc2-bug-report-print.patch ];
			# 		});
			# 	}
			# ];
		};
	}

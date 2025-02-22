{config, lib, pkgs, ...}:
	let cfg = config.localModule;
	in
	{
		options.localModule = {
			plasma.enable = lib.mkEnableOption "the KDE Plasma desktop environment";
			plasma.minimal.enable = lib.mkEnableOption "a minimal KDE Plasma installation";
		};

		config = lib.mkIf cfg.plasma.enable {
			#nixpkgs.overlays = [(self: super: {
			#	kdePackages.plasma-activities-stats = super.kdePackages.plasma-activities-stats.overrideAttrs(old: {
			#			# Doesn't have patches
			#			patches =  [
			#				./patches/fix-kde-recents-loading.patch
			#			];
			#		});
			#})];
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
				] ++ lib.optionals (! cfg.kde.minimal.enable) [
					# Sound
					kid3-kde

					# Video players/MPV Frontends
					haruna 

					# Audio players
					fooyin

					# Chat Apps
					kdePackages.neochat nheko kaidan
			
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
				];
				sessionVariables = {
					# System wide stem darkening
					FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
				};
			};

			system.replaceDependencies.replacements = [
			];
		};
	}

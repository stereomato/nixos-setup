{config, lib, pkgs, ...}:
	let cfg = config.localModule;
	in
	{
		options.localModule = {
			plasma.enable = lib.mkEnableOption "the KDE Plasma desktop environment";
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

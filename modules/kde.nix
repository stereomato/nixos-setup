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
			};

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
				{
					oldDependency = pkgs.kdePackages.plasma-activities-stats;
					newDependency = pkgs.kdePackages.plasma-activities-stats.overrideAttrs(old: {
						# Doesn't have patches
						patches =  [
							./patches/fix-kde-recents-loading.patch
						];
					});
				}
			];
		};
	}

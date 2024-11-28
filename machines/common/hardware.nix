{ lib, pkgs, ... }:
{
	hardware = {
		
		pulseaudio.enable = false; # because of pipewire
		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};
		enableAllFirmware = true;
		
		cpu.intel.updateMicrocode = true;
		#xone.enable = true; # xbox one controllers
		sane = {
			# scanners and printers
			# TODO: investigate about the backends when I have a printer or need to use a printer
			enable = true;
			openFirewall = true;
		};
		sensor.iio.enable = true;

		graphics = {
			enable = true;
			#driSupport = true;
			enable32Bit = true;

			extraPackages = with pkgs; [ 
				# HW media acceleration
				intel-media-sdk
				intel-media-driver

				# Compute aka openCL
				intel-compute-runtime

				# Mangohud layers
				mangohud
			];
			extraPackages32 = with pkgs; [
				# Mangohud layers
				pkgsi686Linux.mangohud
			];
		};
	};

	security.rtkit.enable = true; # for pipewire
	services = {
		# power saving
		# TODO: might be replaced by tuned-ppd someday in the future on nixOS
		power-profiles-daemon.enable = true;
		
		# Audio + Video backend server
		# Also important for pro audio
		pipewire = {
			enable = true;
			audio.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
			pulse.enable = true;
			jack.enable = true;
		};
		# Firmware updates
		fwupd.enable = true;

		printing = {
			enable = true;
			cups-pdf = {
				enable = true;
			};
			drivers = with pkgs; [
				canon-cups-ufr2
				cnijfilter2
			];
		};
	};

	# Thunderbolt
	services.hardware.bolt.enable = true;

	# wacom tablets
	services.xserver.wacom.enable = true;

	# Power saving
	powerManagement = {
			enable = true;
			cpuFreqGovernor = lib.mkDefault "powersave";
			powertop.enable = true;
			scsiLinkPolicy = "med_power_with_dipm";
	};

	# Wifi power saving
	networking.networkmanager = {
		# This is already enabled because of gnome related toggles.
		wifi = {
			powersave = true;
		};
	};
}

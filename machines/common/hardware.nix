{ pkgs, ... }:
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
}

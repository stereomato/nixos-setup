{ pkgs, ... }:
{
	hardware = {
		ksm = {
			enable = true;
			sleep = 1000;
		};
		pulseaudio.enable = false; # because of pipewire
		bluetooth = {
			# Enabled already because of gnome related toggles.
			powerOnBoot = true;
			#package = "pkgs.bluezFull";
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

		opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
			# temporary until it's fixed:
			#package = pkgs.mesa-intel-fix.drivers;
			#package32 = pkgs.mesa-intel-fix32.drivers;
			
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
				mangohud
			];
		};
	};
}
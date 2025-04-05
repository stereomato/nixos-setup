{config, lib, pkgs, ...}:{
  imports = [
		./audio.nix
		./boot.nix
		./gpu.nix
  ];

	# Thunderbolt
	services = {
		hardware.bolt.enable = true;
		xserver = {
			# Wacom tablets
			wacom.enable = true;
			# Keyboard layout
			xkb.layout = "latam";
		};
		printing = {
			enable = true;
			cups-pdf = {
				enable = true;
			};
			drivers = with pkgs; [
				cnijfilter2
			];
		};
		udev.extraRules = ''
				# Arduino
				SUBSYSTEMS=="usb-serial", TAG+="uaccess"
		'';
  };

  hardware = {
	bluetooth.enable = true;
	enableAllFirmware = true;
		cpu.intel.updateMicrocode = true;
		#xone.enable = true; # xbox one controllers
		# scanners and printers
		sane = {
			enable = true;
			openFirewall = true;
		};
		sensor.iio.enable = true;
	};

	# Keyboard Layout
	# Not gonna have any other kind of keyboard layout anytime soon, so put this in common
	console.keyMap = "la-latin1";
}

{ pkgs, ... }:{
	virtualisation = {
		spiceUSBRedirection.enable = true;
		libvirtd = {
			enable = true;
			qemu = {
				runAsRoot = false;
				swtpm.enable = true;
			};
		};
		podman = {
			enable = true;
		};
		waydroid = {
			enable = true;
		};
	};

	environment.systemPackages = with pkgs; [
		# Virtualization and containerization
		# NO GNOME
		# gnome.gnome-boxes
	];
}

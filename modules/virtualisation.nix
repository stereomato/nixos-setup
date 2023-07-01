{ lib, pkgs, ... }:{
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
		vmware = {
			guest = {
				enable = true;
			};
			host = {
				#enable = true;
			};
		};
	};
}
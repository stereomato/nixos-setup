{ config, lib, pkgs, ... }:
{

	boot = {
		initrd.luks.devices."TaihouDisk" = {
			# device = "/dev/disk/by-uuid/6cd37ac7-ae6a-4049-b0a9-4b9bc54c71f3";
			allowDiscards = true;
			bypassWorkqueues = true;
		};
		kernelParams = [
			# Enable deep sleep
			"mem_sleep_default=deep"
		];
	};
}

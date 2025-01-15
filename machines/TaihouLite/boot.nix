{ config, lib, pkgs, ... }:
{

	boot = {
		kernelParams = [
			# Enable deep sleep
			"mem_sleep_default=deep"
		];
		zfs.enabled = false;
	};
}

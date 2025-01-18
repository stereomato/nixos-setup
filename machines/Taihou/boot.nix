{ config, lib, pkgs, ... }:
{

	boot = {
		kernelParams = [
			# Enable deep sleep
			"mem_sleep_default=deep"
		];
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L18
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L19
		supportedFilesystems.zfs = lib.mkForce false;
		initrd.supportedFilesystems.zfs = lib.mkForce false;
	};
}

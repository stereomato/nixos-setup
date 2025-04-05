{ config, lib, pkgs, ... }:
{

	boot = {
		kernelPackages = lib.mkForce pkgs.linux-stereomato-zen;
		kernelPatches = [
			{
				# https://www.phoronix.com/news/Linux-6.2-Power-Management
				name = "Set the Intel EPP change to ADL, adapted from EPB. Check patch comment for details.";
				patch = ./patches/intel-epp-fix.patch;
			}
		];
		kernelParams = [
			# Enable deep sleep
			# "mem_sleep_default=deep"

			# Testing the Xe kernel driver
			# "i915.force_probe=!46a6"
			# "xe.force_probe=46a6"

			# Enable Intel IOMMU
			"intel_iommu=on"
		];
		extraModprobeConfig = ''
			# Godforsaken MT7921
			options mt7921e disable_aspm=Y
		'';
		# initrd.availableKernelModules = [ "" ];
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L18
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L19
		supportedFilesystems.zfs = lib.mkForce false;
		initrd.supportedFilesystems.zfs = lib.mkForce false;
	};
}

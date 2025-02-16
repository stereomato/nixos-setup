{ config, lib, pkgs, ... }:
{

	nixpkgs.overlays = [
		(self: super: {
		})
	]
	;

	boot = {
		kernelPatches = [
			{
				# https://www.phoronix.com/news/Linux-6.2-Power-Management
				name = "Set the Intel EPB change to ADL as a whole. Check comment for details.";
				patch = ./patches/intel-epb-fix.patch;
			}
		];
		kernelParams = [
			# Enable deep sleep
			"mem_sleep_default=deep"

			# Testing the Xe kernel driver
			# "i915.force_probe=!46a6"
			# "xe.force_probe=46a6"

			# Enable Intel IOMMU
			"intel_iommu=on"
		];
		# initrd.availableKernelModules = [ "" ];
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L18
		# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/tasks/filesystems/zfs.nix#L19
		supportedFilesystems.zfs = lib.mkForce false;
		initrd.supportedFilesystems.zfs = lib.mkForce false;
		# kernelPackages = lib.mkForce pkgs.linux-stereomato-zen;
	};
}

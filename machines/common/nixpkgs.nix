{ ... }:
{
	imports = [
		./imports/overlays.nix
	];

	nixpkgs = {
		config = {
			allowUnfree = true;
			joypixels.acceptLicense = true;
			input-fonts.acceptLicense = true;
			permittedInsecurePackages = [
					# FIXME: https://github.com/NixOS/nixpkgs/issues/269713
					"openssl-1.1.1w"
					# FIXME: https://github.com/NixOS/nixpkgs/pull/280835
					"freeimage-unstable-2021-11-01"
			];
		};
	};
}
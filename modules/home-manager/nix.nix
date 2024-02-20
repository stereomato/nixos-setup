{ pkgs, ... }:{
	nix = {
		package = pkgs.nix;
		settings = {
			substituters = [
				# nixpkgs
				"https://cache.nixos.org"
				# nixified-ai
				"https://ai.cachix.org"
			];
		};
	};
}
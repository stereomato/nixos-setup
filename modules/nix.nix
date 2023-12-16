{ inputs, lib, ... }:
{
	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [ 
				"nix-command"
				"flakes"
			];
			# nproc / 2, just in case
			# Not enough ram on my current laptop
			# I think 2GB x thread is good
			# I only have 12GB of ram
			# 4 x 2 = 8, should be fine...
			cores = 4;
			trusted-substituters = [
			# nixified-ai
			"https://ai.cachix.org"
			];
			trusted-public-keys = [
			# nixified-ai
			"ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
			];
		};
		gc = {
			persistent = true;
			automatic = true;
			dates = "sunday";
			options = "--delete-older-than 15d";
		};
		optimise = {
			# This used to be set to saturdays, but this running at the same time as the garbage collector might cause issues.
			dates = [ "saturday" ];
			automatic = true;
		};
		daemonIOSchedClass = "idle";
		daemonCPUSchedPolicy = "idle";
		# Set this thanks to:
		# https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html
		registry.nixpkgs.flake = inputs.nixpkgs;
		
	};
}
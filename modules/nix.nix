{ lib, ... }:
{
	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [ 
				"nix-command"
				"flakes"
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
	};
}
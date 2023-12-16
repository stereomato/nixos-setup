{ ...}:
{
	systemd = {
		tmpfiles = {
			# Enable HWP dynamic boosting
			rules = [ 
				"w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
			];
		};
		oomd = {
			#TODO: Keep an eye on https://github.com/NixOS/nixpkgs/pull/225747
			# enable = true;
			enableSystemSlice = true;
			# enableRootSlice = false;
			enableUserServices = true;
			extraConfig = {
				DefaultMemoryPressureLimit = "90%";
				SwapUsedLimit = "90%";
			};
		};
	};
}
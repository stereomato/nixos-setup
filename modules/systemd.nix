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
			# Enabled by default
			# enable = true;
			# enableSystemSlice = true;
			# 
			enableRootSlice = true;
			enableUserSlices = true;
			extraConfig = {
				DefaultMemoryPressureLimit = "90%";
				SwapUsedLimit = "90%";
			};
		};
	};
}
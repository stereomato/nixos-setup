{ lib, ...}:
{
	systemd = {
		tmpfiles = {
			# Test this...
			#rules = [ 
			#	"w /sys/devices/system/cpu/intel_pstate/hwp_dynamic_boost - - - - 1"
			#];
		};
	};
}
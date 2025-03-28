{
	config,
	lib,
	pkgs,
	...
}:
let
	cfg = config.localModule;
in
{
	###### interface
	options = {
		localModule.intel_lpmd = {
			enable = lib.mkEnableOption "Intel's low power mode daemon";
			# What is the point of this, even?
			# There's not going to be another, alternative intel_lpmd
			package = lib.mkPackageOption pkgs "intel_lpmd" { };


			settings = lib.mkOption {
				default = '''';
				description = ''
					Configuration for the daemon, written to `/etc/intel_lpmd`.
					See `man 5 intel_lpmd_config.xml` for available configuration.
					Doesn't work either lol.
					https://github.com/intel/intel-lpmd/issues/84
				'';

				type = with lib.types; nullOr lines;
			};
		};
	};

	###### implementation
	config = lib.mkIf cfg.intel_lpmd.enable {
		environment = {
			etc."intel_lpmd/intel_lpmd_config.xml".text = cfg.intel_lpmd.settings;
			systemPackages = [ cfg.intel_lpmd.package ];
		};

		services.dbus.packages = [ cfg.intel_lpmd.package ];
		systemd.packages = [ cfg.intel_lpmd.package ];
		
		systemd.services.intel_lpmd.enable = true;
		systemd.services.intel_lpmd.wantedBy = [ "multi-user.target" ];
		# TODO: document this on a personal database thing
		# https://github.com/NixOS/nixpkgs/issues/63703#issuecomment-504836857
		 systemd.services.intel_lpmd.serviceConfig.ExecStart = [
		 	""
		 	"${cfg.intel_lpmd.package}/sbin/intel_lpmd --systemd --dbus-enable --loglevel=debug"
		 ];
	};
}
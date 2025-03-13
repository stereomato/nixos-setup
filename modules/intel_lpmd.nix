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
      systemPackages = [ pkgs.intel_lpmd ];
    };

    services.dbus.packages = [ pkgs.intel_lpmd ];
    systemd.packages = [ pkgs.intel_lpmd ];
    
    systemd.services.intel_lpmd.enable = true;
    systemd.services.intel_lpmd.wantedBy = [ "multi-user.target" ];
  };
}
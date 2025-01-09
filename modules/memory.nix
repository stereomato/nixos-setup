{config, lib, pkgs, ...}:
let cfg = config.localModule.performance.memory;
in 
{
  options.localModule.performance.memory = {
    zswap = {
      enable = lib.mkEnableOption "zswap";
      size = lib.mkOption {
        default = 16384;
        type = lib.types.nullOr lib.types.int;
        description = "Size of the swap partition for zswap.";
      };
      encryption = lib.mkEnableOption "encryption for the swap device. This disables hibernation.";
    };
    zram = {
      enable = lib.mkEnableOption "zram, for memory compression.";
      size = lib.mkOption {
        default = 100;
        description = "Size (in % of ram) of the zram device. Default size is the same as the machine's ram.";
        type = lib.types.ints.between 1 999;
      };
    };
  };

  config = lib.mkIf (cfg.zswap.enable) {
    # Disk based swap
	  swapDevices = [{
      device = "/swap/swapfile";
      # TODO: make this adaptive!
      size = cfg.zswap.size;
      discardPolicy = "both";
      randomEncryption = {
        enable = lib.mkIf (cfg.zswap.encryption) true; 
        allowDiscards = true;
        keySize = 256;
      };
    }];
    boot.kernelParams = lib.mkIf (cfg.zswap.encryption) ["nohibernate"];
  } // lib.mkIf (cfg.zram.enable) {
    zramSwap = {
      enable = true;
      memoryPercent = cfg.zram.size;
    };
  };
}
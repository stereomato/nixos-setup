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
    boot.kernelParams = [ 
      # Zswap settings
			"zswap.enabled=Y"
			"zswap.compressor=zstd"
			"zswap.zpool=zsmalloc"
			"zswap.max_pool_percent=35"
			"zswap.accept_threshold_percent=90"
    ] ++ lib.optionals (cfg.zswap.encryption) ["nohibernate"];
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
		# TODO: Fix this
  # } // lib.optionalAttrs (cfg.zram.enable) {
  #   boot.kernelParams = [ "zswap.enabled=N" ];
  #   zramSwap = {
  #     enable = true;
  #     memoryPercent = cfg.zram.size;
  #   };
  };
}
{ ... }:{
	swapDevices = [{
		device = "/swap/Taihou-SWAP";
		size = 17365;
		discardPolicy = "both";
		randomEncryption = {
			enable = true; 
			allowDiscards = true;
		};
		# This is in case of zram
		# Currently, the device doesn't exist.
		#device = "/dev/nvme0n1p3";
		#options = [ "noauto" ];
	}];
}
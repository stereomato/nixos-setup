{ ... }:{
	zramSwap = {
		enable = true;
		algorithm = "lz4";
		memoryPercent = 200;
		#writebackDevice = "/dev/nvme0n1p3";
	};
}
{ ... }:{
	zramSwap = {
		enable = false;
		algorithm = "zstd";
		memoryPercent = 200;
		writebackDevice = "/dev/nvme0n1p3";
	};
}
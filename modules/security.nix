{ ... }:
{
	security = {
		protectKernelImage = true;
		
		pam = {
			loginLimits = [
				{
					domain = "@audio";
					type = "-";
					item = "rtprio";
					value = 98;
				}
				{
					domain = "@audio";
					type = "-";
					item = "memlock";
					value = "unlimited";
				}
				{
					domain = "@audio";
					type = "-";
					item = "nice";
					value = -11;
				}
			];
		};
		sudo = {
			enable = true;
		};
		rtkit.enable = true; # for pipewire
		polkit.enable = true;
	};
}
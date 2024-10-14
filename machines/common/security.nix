{ ... }:
{
	security = {
		protectKernelImage = true;
		
		
		sudo = {
			enable = true;
		};
		
		polkit.enable = true;
	};
}
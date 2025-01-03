{ pkgs, ... }:{
	environment = {
		localBinInPath = true;
		shells = with pkgs; [ fish ];
	};
	programs.fish = {
			enable = true; 
			useBabelfish = true;
		};
}

{ ... }:{
  imports = [
    ./imports
    ./media
    
    ./envvars.nix
    ./file.nix
    ./gaming
    ./home.nix
    ./internet.nix
    ./nix.nix
    ./programs.nix
    ./services.nix
    ./software-development
  ];


  fonts = {
		fontconfig = {
			enable = true;
		};
	};
}
{ ... }:{
  imports = [
    ./imports
    ./media
    
    ./envvars.nix
    ./file.nix
    ./gaming.nix
    ./home.nix
    ./internet.nix
    ./nix.nix
    ./programs.nix
    ./services.nix
    ./software-development.nix
  ];


  fonts = {
		fontconfig = {
			enable = true;
		};
	};
}
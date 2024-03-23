{ ... }:{
  imports = [
    ./imports
    ./media
    
    ./envvars.nix
    ./file.nix
    ./pkgs/gaming.nix
    ./home.nix
    ./pkgs/internet.nix
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
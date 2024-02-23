{
	description = "Stereomato's NixOS setup";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
		nix-index-database = {
			url = "github:Mic92/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixified-ai = {
			url = "github:nixified-ai/flake";
			#inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	outputs = { self, nixpkgs, home-manager, nix-index-database, ... }@inputs: {
			nixosConfigurations = {
				Taihou = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [ 
						./modules/boot.nix
						./modules/console.nix
						./modules/environment.nix
						./modules/documentation.nix
						./modules/filesystems.nix
						./modules/fonts.nix
						./modules/gtk.nix
						./modules/hardware.nix
						./modules/home.nix
						./modules/i18n.nix
						./modules/networking.nix
						./modules/nix.nix
						nix-index-database.nixosModules.nix-index
						./modules/nixpkgs.nix
						./modules/powerManagement.nix
						./modules/programs.nix
						./modules/qt.nix
						./modules/security.nix
						./modules/services.nix
						./modules/swapDevices.nix
						./modules/system.nix
						./modules/systemd.nix
						./modules/time.nix
						./modules/users.nix
						./modules/virtualisation.nix
						./modules/zramSwap.nix
						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.extraSpecialArgs = { inherit inputs; installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup"; };
							 home-manager.users.stereomato.imports = [
									./modules/file.nix
								# ./modules/home-manager/fonts.nix
								# ./modules/home-manager/gtk.nix
								# ./modules/home-manager/home.nix
								# ./modules/home-manager/nix.nix
								# ./modules/home-manager/nixpkgs.nix
								# ./modules/home-manager/programs.nix
								# ./modules/home-manager/qt.nix
								# ./modules/home-manager/services.nix
								# ./modules/home-manager/systemd.nix
							 ];
						}
						
						# from hardware-configuration.nix
						#(modulesPath + "/installer/scan/not-detected.nix")
					];
					specialArgs = { inherit inputs; username = "stereomato"; };
				};
			};
		};
}

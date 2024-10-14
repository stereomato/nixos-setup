{
	description = "Stereomato's NixOS setup";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-24.05";
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
			
			nixosConfigurations = rec {
				
				Taihou = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [ 
						./machines/Taihou
						nix-index-database.nixosModules.nix-index
						
						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = false;
							home-manager.useUserPackages = true;
							home-manager.extraSpecialArgs = { username = "stereomato"; inherit inputs; installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup"; };
							 home-manager.users.stereomato.imports = [
									./users/stereomato
									nix-index-database.hmModules.nix-index
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

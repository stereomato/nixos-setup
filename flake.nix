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
	
	outputs = { self, nixpkgs, home-manager, ... }@inputs: {
			nixosConfigurations = {
				Taihou = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [ 
						./modules/nixos/boot.nix
						./modules/nixos/console.nix
						./modules/nixos/environment.nix
						./modules/nixos/documentation.nix
						./modules/nixos/filesystems.nix
						./modules/nixos/fonts.nix
						./modules/nixos/hardware.nix
						./modules/nixos/i18n.nix
						./modules/nixos/networking.nix
						./modules/nixos/nix.nix
						./modules/nixos/nixpkgs.nix
						./modules/nixos/powerManagement.nix
						./modules/nixos/programs.nix
						./modules/nixos/qt.nix
						./modules/nixos/security.nix
						./modules/nixos/services.nix
						./modules/nixos/swapDevices.nix
						./modules/nixos/system.nix
						./modules/nixos/systemd.nix
						./modules/nixos/time.nix
						./modules/nixos/users.nix
						./modules/nixos/virtualisation.nix
						./modules/nixos/zramSwap.nix
						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.extraSpecialArgs = { inherit inputs; };
							home-manager.users.stereomato.imports = [
								./modules/home-manager/fonts.nix
								./modules/home-manager/gtk.nix
								./modules/home-manager/home.nix
								./modules/home-manager/nix.nix
								./modules/home-manager/nixpkgs.nix
								./modules/home-manager/programs.nix
								./modules/home-manager/qt.nix
								./modules/home-manager/services.nix
								./modules/home-manager/systemd.nix
							];
						}
						
						# from hardware-configuration.nix
						#(modulesPath + "/installer/scan/not-detected.nix")
					];
					specialArgs = { inherit inputs; };
				};
			};
		};
}

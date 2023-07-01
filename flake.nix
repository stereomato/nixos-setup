{
	description = "Pearsche's NixOS setup";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
	};
	
	outputs = { self, nixpkgs }: {
			nixosConfigurations = {
				Taihou = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [ 
						./modules/boot.nix
						./modules/console.nix
						./modules/environment.nix
						./modules/filesystems.nix
						./modules/fonts.nix
						./modules/hardware.nix
						./modules/i18n.nix
						./modules/networking.nix
						./modules/nix.nix
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
						# from hardware-configuration.nix
						#(modulesPath + "/installer/scan/not-detected.nix")
					];
				};
			};
		};

}
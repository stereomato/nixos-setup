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
						./boot.nix
						./console.nix
						./environment.nix
						./filesystems.nix
						./fonts.nix
						./hardware.nix
						./i18n.nix
						./networking.nix
						./nix.nix
						./nixpkgs.nix
						./powerManagement.nix
						./programs.nix
						./qt.nix
						./security.nix
						./services.nix
						./swapDevices.nix
						./system.nix
						./systemd.nix
						./time.nix
						./users.nix
						./virtualisation.nix
						./zramSwap.nix
						# from hardware-configuration.nix
						#(modulesPath + "/installer/scan/not-detected.nix")
					];
				};
			};
		};

}
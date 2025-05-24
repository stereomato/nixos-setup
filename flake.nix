{
	description = "Stereomato's NixOS setup";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
		nix-index-database = {
			url = "github:Mic92/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko = {
				url = "github:nix-community/disko/latest";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		aagl = {
			url = "github:ezKEa/aagl-gtk-on-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, nix-index-database, disko, aagl, ... }@inputs: let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
			inherit system;
			# TODO: Delete this if overlays work fine under each system.
			# TODO: Consider making general overlays for multiple machines
			overlays = [
				# TODO: Someday get how the n-v-e overlay works/is constructed
				inputs.nix-vscode-extensions.overlays.default
				] ++ import ./overlay;
		hostPlatform = system;
		config = {
			allowUnfree = true;
			allowUnfreePredicate = _: true;
			joypixels.acceptLicense = true;
			input-fonts.acceptLicense = true;
			permittedInsecurePackages = [
					# FIXME: https://github.com/NixOS/nixpkgs/issues/269713
					# It's for steam
					"openssl-1.1.1w"
					# FIXME: https://discourse.nixos.org/t/nixpkgs-config-permittedinsecurepackages-cannot-be-set-in-multiple-files-at-the-same-time/56128
					"olm-3.2.16"
			];
		};
	};
		in rec {
			nixosConfigurations = {
				Taihou = nixpkgs.lib.nixosSystem {
					system = system;
					pkgs = pkgs;
					modules = [
						aagl.nixosModules.default
						nix-index-database.nixosModules.nix-index
						disko.nixosModules.disko
						./modules/default.nix
						./machines/Taihou
						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.backupFileExtension = "homeManagerBackupFile";
							home-manager.users.stereomato = import ./users/stereomato/hm;
							home-manager.extraSpecialArgs = {
								# Read my laptop config
								taihouConfig = nixosConfigurations.Taihou.config;
								username = "stereomato";
								inherit inputs;
								installPath = "/etc/nixos";
							};
    	        # Optionally, use home-manager.extraSpecialArgs to pass
  	          # arguments to home.nix
	          }
					];
					specialArgs = { inherit inputs; username = "stereomato"; };
				};

				# nix build .#nixosConfigurations.TaihouLite.config.system.build.isoImage
				TaihouLite = nixpkgs.lib.nixosSystem {
					system = system;
					pkgs = pkgs;
					modules = [
						nix-index-database.nixosModules.nix-index
						disko.nixosModules.disko
						./modules/default.nix
						./machines/TaihouLite
					];
					specialArgs = { inherit inputs; username = "stereomato"; };
				};

				Hearts = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [
						./machines/Hearts
						./modules/default.nix
						nix-index-database.nixosModules.nix-index
					];
					specialArgs = { inherit inputs; };
				};
			};
			# TODO: An example of homeConfigurations should be @ the home-manager manual
			# Unneeded now
			# homeConfigurations = {
			# 	"stereomato@Taihou" = home-manager.lib.homeManagerConfiguration {
			# 		inherit pkgs;
			# 		# backupFileExtension = "hm-backup";
			# 		extraSpecialArgs = {
			# 			# Read my laptop config
			# 			taihouConfig = nixosConfigurations.Taihou.config;
			# 			username = "stereomato";
			# 			inherit inputs;
			# 			installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup";
			# 		};
			# 		modules = [
			# 			./users/stereomato/hm
			# 			nix-index-database.hmModules.nix-index
			# 		];
			# 	};
			# };
		};
}

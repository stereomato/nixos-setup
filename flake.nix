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
		
		# This is for mutter with the triple buffering patch
		# taken from https://gitlab.com/MikeTTh/nix-dots/-/blob/e1594af5882a53b4b25f99bdc5361dce4d33770d/flake.nix#L39-47
		mutter-triple-buffering-src = {
			url = "gitlab:vanvugt/mutter?ref=triple-buffering-v4-47&host=gitlab.gnome.org";
			flake = false;
		};

		gvdb-src = {
			url = "gitlab:GNOME/gvdb?ref=main&host=gitlab.gnome.org";
			flake = false;
		};
	};

	outputs = { self, nixpkgs, home-manager, nix-index-database, disko, ... }@inputs: let
	system = "x86_64-linux";
	pkgs = import nixpkgs {
			inherit system;
			# TODO: Delete this if overlays work fine under each system.
			# TODO: Consider making general overlays for multiple machines
			overlays = [
				inputs.nix-vscode-extensions.overlays.default
				(self: super: {
				intel_lpmd = super.callPackage ./modules/pkgs/intel_lpmd.nix {};
			})];
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
								installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup";
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

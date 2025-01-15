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
		nixified-ai = {
			url = "github:nixified-ai/flake";
			#inputs.nixpkgs.follows = "nixpkgs";
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
			overlays = [(self: super: {
				# intel-lpmd = inputs.intel-lmpd-module.outputs.legacyPackages.x86_64-linux.intel-lpmd;
			})];
		hostPlatform = system;
			config = {
				allowUnfree = true;
				allowUnfreePredicate = _: true;
			};
		};
			in rec {
			nixosConfigurations = {
				Taihou = nixpkgs.lib.nixosSystem {
					system = system;
					modules = [
						nix-index-database.nixosModules.nix-index
						disko.nixosModules.disko
						./modules/default.nix
						./machines/Taihou
					];
					specialArgs = { inherit inputs; username = "stereomato"; };
				};

				TaihouIso = nixpkgs.lib.nixosSystem {
					system = system;
					modules = [
						./machines/Taihou
						./machines/TaihouIso
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
			homeConfigurations = {
				"stereomato@Taihou" = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					# backupFileExtension = "hm-backup";
					extraSpecialArgs = {
						# Read my laptop config
						taihouConfig = nixosConfigurations.Taihou.config;
						username = "stereomato";
						inherit inputs;
						installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup";
					};
					modules = [
						./users/stereomato/hm
						nix-index-database.hmModules.nix-index
					];
				};
			};
		};
}

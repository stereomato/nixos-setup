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
	
	outputs = { self, nixpkgs, home-manager, nix-index-database, ... }@inputs: let 
	system = "x86_64-linux";
	pkgs = import nixpkgs {
      inherit system;
      # TODO: Delete this if overlays work fine under each system.
			# TODO: Consider making general overlays for multiple machines
			# overlays = [
      # ];
		hostPlatform = system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
			in {
			nixosConfigurations = rec {
				Taihou = nixpkgs.lib.nixosSystem {
					system = system;
					modules = [ 
						./machines/Taihou
						nix-index-database.nixosModules.nix-index
						
						# # TODO: refactor this so that it is its own thing so that nixd just works
						# home-manager.nixosModules.home-manager {
						# 	# Added because changing KDE font settings messes with 10-hm-fonts.conf.
						# 	# Doesn't even add anything to it, just formats it by deleting the newlines!
						# 	home-manager.backupFileExtension = "hm-backup";
						# 	home-manager.useGlobalPkgs = false;
						# 	home-manager.useUserPackages = false;
						# 	home-manager.extraSpecialArgs = { username = "stereomato"; inherit inputs; installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup"; };
							
						# 	home-manager.users.stereomato.imports = [
						# 			./users/stereomato
						# 			nix-index-database.hmModules.nix-index
						# 	 ];
						# }
						
						# from hardware-configuration.nix
						#(modulesPath + "/installer/scan/not-detected.nix")
					];
					specialArgs = { inherit inputs; username = "stereomato"; };
				};

				Hearts = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [
						./machines/Hearts
						nix-index-database.nixosModules.nix-index
					];
				};
			};
			# TODO: An example of homeConfigurations should be @ the home-manager manual
			homeConfigurations = {
				"stereomato@Taihou" = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					# backupFileExtension = "hm-backup";
					extraSpecialArgs = { username = "stereomato"; inherit inputs; installPath = "/home/stereomato/Documents/Software Development/Repositories/Personal/nixos-setup"; };
					modules = [
						./users/stereomato
					];
				};
			};
		};
}

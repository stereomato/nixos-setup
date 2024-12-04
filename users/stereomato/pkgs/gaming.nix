{ pkgs, ... }:{
	home.packages = with pkgs; [
		# Windows related stuff
		wineWowPackages.stagingFull dxvk  winetricks proton-caller bottles

		# Games & Fun
		# minecraft (official launcher) https://github.com/NixOS/nixpkgs/issues/179323
		prismlauncher protontricks sl stuntrally tome4 gamescope
		
		# I don't play this
		# vintagestory
		
		# Marked broken
		# minecraft
		
		# Emulators
		# rip citra-nightly
		dolphin-emu-beta ppsspp-sdl-wayland # pcsx2
	];

	programs.mangohud = {
		enable = true;
	};
}
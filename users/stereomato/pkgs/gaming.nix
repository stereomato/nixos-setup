{ pkgs, ... }:{
  users.users.stereomato.packages = with pkgs; [
		# Windows related stuff
		wineWowPackages.stagingFull dxvk  winetricks proton-caller bottles

		# Games & Fun
		# minecraft (official launcher) https://github.com/NixOS/nixpkgs/issues/179323
		prismlauncher protontricks sl gamescope

		# Emulators
		dolphin-emu-beta ppsspp-sdl-wayland # pcsx2
	];
}
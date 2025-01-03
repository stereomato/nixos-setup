{config, lib, pkgs, ...}:{
  users.users.stereomato.packages = with pkgs; [
		# https://github.com/NixOS/nixpkgs/issues/242322#issuecomment-2264995861
		jetbrains-toolbox

		zed-editor

		toolbox distrobox
		# Computer Graphics
		# blender builds from source lmfao fuck that

		# Compilers, configurers
		patchelf

		# Terminals
		# blackbox-terminal

		# Nix tooling
		nixd
		nix-prefetch-scripts niv nil

		# Debuggers
		gdb valgrind

		# Code editors/IDEs
		netbeans

		# Documentation tools
		zeal

		# Java libraries
		commonsIo

		# Gamedev

		unityhub # https://nixpk.gs/pr-tracker.html?pr=368851
		
		# IDC: godot3-mono godot3-mono-export-templates

		## This is for godot's C# support
		# msbuild

		# Arduino
		arduino-ide
  ];
}
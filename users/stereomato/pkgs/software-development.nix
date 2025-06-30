{ pkgs, ...}:{
	
	users.users.stereomato.packages = with pkgs; [
		# https://github.com/NixOS/nixpkgs/issues/242322#issuecomment-2264995861
		# Text editors, IDEs
		zed-editor netbeans arduino-ide my-vscode octaveFull

		toolbox distrobox
		# Computer Graphics
		# blender 
		
		# Compilers, configurers
		patchelf

		# Nix tooling
		nixd nix-prefetch-scripts 

		# Debuggers
		gdb valgrind

		# Documentation tools
		zeal

		# Java libraries
		commonsIo

		# Gamedev
		#unityhub # https://nixpk.gs/pr-tracker.html?pr=368851

		# Containers
		arion

		# mysql
		mysql-workbench
		# Misc
		swi-prolog-gui
  ];
}

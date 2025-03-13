{ pkgs, ...}:{
  nixpkgs.overlays = [(
		self: super: {
			vscode = super.vscode.override {
				commandLineArgs = "--disable-font-subpixel-positioning=true";
			};
			# TODO: Adapt this to use forVSCodeVersion
			my-vscode = super.vscode-with-extensions.override { 
				vscodeExtensions = [
					# Superseded by the direnv extension
					#pkgs.vscode-marketplace.arrterian.nix-env-selector
					pkgs.vscode-marketplace.donjayamanne.githistory
					pkgs.vscode-marketplace.eamodio.gitlens
					pkgs.vscode-marketplace.formulahendry.code-runner
					pkgs.vscode-marketplace.github.github-vscode-theme
					pkgs.vscode-marketplace.github.vscode-pull-request-github
					pkgs.vscode-marketplace.jnoortheen.nix-ide
					pkgs.vscode-marketplace.mkhl.direnv
					pkgs.vscode-marketplace.ms-python.python
					pkgs.vscode-marketplace.ms-toolsai.jupyter
					pkgs.vscode-marketplace.ms-toolsai.jupyter-keymap
					pkgs.vscode-marketplace.ms-toolsai.jupyter-renderers
					# pkgs.vscode-marketplace.ms-dotnettools.csdevkit
					# pkgs.vscode-marketplace.ms-dotnettools.csharp
					# pkgs.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
					pkgs.vscode-marketplace.ms-vscode.remote-server
					pkgs.vscode-marketplace.ms-vscode-remote.remote-ssh
					pkgs.vscode-marketplace.ms-vscode.cmake-tools
					# https://github.com/nix-community/nix-vscode-extensions/issues/69
					pkgs.vscode-extensions.ms-vscode.cpptools
					pkgs.vscode-marketplace.ms-vscode.hexeditor
					pkgs.vscode-marketplace.ms-vscode.theme-tomorrowkit
					pkgs.vscode-marketplace.piousdeer.adwaita-theme
					pkgs.vscode-marketplace.pkief.material-product-icons
					pkgs.vscode-marketplace.pkief.material-icon-theme
					pkgs.vscode-marketplace.redhat.java
					pkgs.vscode-marketplace.rust-lang.rust-analyzer
					# pkgs.vscode-marketplace.skyapps.fish-vscode
					pkgs.vscode-marketplace.vscjava.vscode-java-debug
					pkgs.vscode-marketplace.vscjava.vscode-java-dependency
					pkgs.vscode-marketplace.vscjava.vscode-java-test
					pkgs.vscode-marketplace.vscjava.vscode-maven
					pkgs.vscode-marketplace.vadimcn.vscode-lldb
					pkgs.vscode-marketplace.nimlang.nimlang
					pkgs.vscode-marketplace.cschlosser.doxdocgen
					pkgs.vscode-marketplace.jeff-hykin.better-cpp-syntax
					# pkgs.vscode-marketplace.jgclark.vscode-todo-highlight
					pkgs.vscode-marketplace.josetr.cmake-language-support-vscode
					
					pkgs.vscode-marketplace.ms-python.isort
					pkgs.vscode-marketplace.ms-python.vscode-pylance
					pkgs.vscode-marketplace.ms-vscode-remote.remote-containers
					pkgs.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
					pkgs.vscode-marketplace.ms-vscode-remote.remote-wsl
					pkgs.vscode-marketplace.ms-vscode.cpptools-extension-pack
					pkgs.vscode-marketplace.ms-vscode.cpptools-themes
					pkgs.vscode-marketplace.ms-vscode.remote-explorer
					# https://github.com/nix-community/nix-vscode-extensions/issues/97
					pkgs.vscode-marketplace.ms-vsliveshare.vsliveshare
					pkgs.vscode-marketplace.jdinhlife.gruvbox
					#pkgs.vscode-marketplace.VisualStudioExptTeam.intellicode-api-usage-examples
					#pkgs.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode
					#pkgs.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-completions
					#pkgs.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-insiders
					pkgs.vscode-marketplace.vscjava.vscode-java-pack
					pkgs.vscode-marketplace.gruntfuggly.todo-tree
					pkgs.vscode-marketplace.bmalehorn.vscode-fish
					pkgs.vscode-marketplace.dart-code.dart-code
					pkgs.vscode-marketplace.dart-code.flutter
					pkgs.vscode-marketplace.dart-code.flutter-local-device-exposer
					pkgs.vscode-marketplace.elixir-tools.elixir-tools
					
					# This was confusing...
					pkgs.vscode-marketplace.jakebecker.elixir-ls
				] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					];
			 };
		}
	)];
	
	users.users.stereomato.packages = with pkgs; [
		# https://github.com/NixOS/nixpkgs/issues/242322#issuecomment-2264995861
		# Text editors, IDEs
		# zed-editor 
		jetbrains-toolbox netbeans arduino-ide my-vscode octaveFull

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
		unityhub # https://nixpk.gs/pr-tracker.html?pr=368851

		# Containers
		arion
  ];
}
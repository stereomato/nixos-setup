{ pkgs, inputs, ... }:{
  programs = {
    vscode = {
			enable = true;
			mutableExtensionsDir = false;
			# This shits up userSettings.json by making it read only.
			#enableUpdateCheck = false;
			extensions = [
				# Superseded by the direnv extension
				#pkgs.vscode-extensions.arrterian.nix-env-selector
				pkgs.vscode-extensions.donjayamanne.githistory
				pkgs.vscode-extensions.eamodio.gitlens
				pkgs.vscode-extensions.formulahendry.code-runner
				pkgs.vscode-extensions.github.github-vscode-theme
				pkgs.vscode-extensions.github.vscode-pull-request-github
				pkgs.vscode-extensions.jnoortheen.nix-ide
				pkgs.vscode-extensions.mkhl.direnv
				pkgs.vscode-extensions.ms-python.python
				pkgs.vscode-extensions.ms-toolsai.jupyter
				pkgs.vscode-extensions.ms-toolsai.jupyter-keymap
				pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
				pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
				pkgs.vscode-extensions.ms-vscode.cmake-tools
				pkgs.vscode-extensions.ms-vscode.cpptools
				pkgs.vscode-extensions.ms-vscode.hexeditor
				pkgs.vscode-extensions.ms-vscode.theme-tomorrowkit
				pkgs.vscode-extensions.piousdeer.adwaita-theme
				pkgs.vscode-extensions.pkief.material-product-icons
				pkgs.vscode-extensions.pkief.material-icon-theme
				pkgs.vscode-extensions.redhat.java
				pkgs.vscode-extensions.matklad.rust-analyzer
				# pkgs.vscode-extensions.skyapps.fish-vscode
				pkgs.vscode-extensions.twxs.cmake
				pkgs.vscode-extensions.vscjava.vscode-java-debug
				pkgs.vscode-extensions.vscjava.vscode-java-dependency
				pkgs.vscode-extensions.vscjava.vscode-java-test
				pkgs.vscode-extensions.vscjava.vscode-maven
				pkgs.vscode-extensions.vadimcn.vscode-lldb
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.kosz78.nim
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.cschlosser.doxdocgen
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jeff-hykin.better-cpp-syntax
				# inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jgclark.vscode-todo-highlight
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.josetr.cmake-language-support-vscode
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.isort
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.vscode-pylance
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-containers
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-wsl
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-extension-pack
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-themes
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.remote-explorer
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vsliveshare.vsliveshare
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.sainnhe.gruvbox-material
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.intellicode-api-usage-examples
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-completions
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-insiders
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-java-pack
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.gruntfuggly.todo-tree
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.bmalehorn.vscode-fish
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.dart-code
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.flutter
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.dart-code.flutter-local-device-exposer
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.elixir-tools.elixir-tools
				# This was confusing...
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jakebecker.elixir-ls
			] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					];
		};
  };
}
{ pkgs, inputs,  ... }:{
  programs = {
    vscode = {
			enable = true;
			mutableExtensionsDir = true;
			# This shits up userSettings.json by making it read only.
			#enableUpdateCheck = false;
			extensions = [
				# Superseded by the direnv extension
				#inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.arrterian.nix-env-selector
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.donjayamanne.githistory
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.eamodio.gitlens
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.formulahendry.code-runner
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.github.github-vscode-theme
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.github.vscode-pull-request-github
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jnoortheen.nix-ide
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.mkhl.direnv
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.python
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-toolsai.jupyter
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-toolsai.jupyter-keymap
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-toolsai.jupyter-renderers
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-dotnettools.csdevkit
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-dotnettools.csharp
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.remote-server
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-ssh
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cmake-tools
				# https://github.com/nix-community/nix-vscode-extensions/issues/69
				pkgs.vscode-extensions.ms-vscode.cpptools
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.hexeditor
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.theme-tomorrowkit
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.piousdeer.adwaita-theme
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.pkief.material-product-icons
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.pkief.material-icon-theme
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.redhat.java
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.rust-lang.rust-analyzer
				# inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.skyapps.fish-vscode
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.twxs.cmake
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-java-debug
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-java-dependency
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-java-test
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vscjava.vscode-maven
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.vadimcn.vscode-lldb
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.kosz78.nim
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.cschlosser.doxdocgen
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jeff-hykin.better-cpp-syntax
				# inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jgclark.vscode-todo-highlight
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.josetr.cmake-language-support-vscode
				
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.isort
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-python.vscode-pylance
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-containers
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode-remote.remote-wsl
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-extension-pack
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.cpptools-themes
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vscode.remote-explorer
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.ms-vsliveshare.vsliveshare
				inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace.jdinhlife.gruvbox
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
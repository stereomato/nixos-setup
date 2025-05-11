let appsOverlay = (
	final: prev: {
		handbrake-stereomato = prev.handbrake.override {
			useFdk = true;
		};
		ffmpeg-fuller = prev.ffmpeg-full.override {
			withUnfree = true;
			# enableLto = true; # fails...
		};
		# FIXME: https://github.com/NixOS/nixpkgs/pull/294710
		gimp-stereomato = prev.gimp.override {
			withPython = true;
		};

		vscode = prev.vscode.override {
			commandLineArgs = "--disable-font-subpixel-positioning=true";
		};
		# TODO: Adapt this to use forVSCodeVersion
		my-vscode = prev.vscode-with-extensions.override { 
			vscodeExtensions = [
				# Superseded by the direnv extension
				#prev.vscode-marketplace.arrterian.nix-env-selector
				prev.vscode-marketplace.donjayamanne.githistory
				prev.vscode-marketplace.eamodio.gitlens
				prev.vscode-marketplace.formulahendry.code-runner
				prev.vscode-marketplace.github.github-vscode-theme
				prev.vscode-marketplace.github.vscode-pull-request-github
				prev.vscode-marketplace.jnoortheen.nix-ide
				prev.vscode-marketplace.mkhl.direnv
				prev.vscode-marketplace.ms-python.python
				prev.vscode-marketplace.ms-toolsai.jupyter
				prev.vscode-marketplace.ms-toolsai.jupyter-keymap
				prev.vscode-marketplace.ms-toolsai.jupyter-renderers
				# prev.vscode-marketplace.ms-dotnettools.csdevkit
				# prev.vscode-marketplace.ms-dotnettools.csharp
				# prev.vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
				prev.vscode-marketplace.ms-vscode.remote-server
				prev.vscode-marketplace.ms-vscode-remote.remote-ssh
				prev.vscode-marketplace.ms-vscode.cmake-tools
				# https://github.com/nix-community/nix-vscode-extensions/issues/69
				prev.vscode-extensions.ms-vscode.cpptools
				prev.vscode-marketplace.ms-vscode.hexeditor
				prev.vscode-marketplace.ms-vscode.theme-tomorrowkit
				prev.vscode-marketplace.piousdeer.adwaita-theme
				prev.vscode-marketplace.pkief.material-product-icons
				prev.vscode-marketplace.pkief.material-icon-theme
				prev.vscode-marketplace.redhat.java
				prev.vscode-marketplace.rust-lang.rust-analyzer
				# prev.vscode-marketplace.skyapps.fish-vscode
				prev.vscode-marketplace.vscjava.vscode-java-debug
				prev.vscode-marketplace.vscjava.vscode-java-dependency
				prev.vscode-marketplace.vscjava.vscode-java-test
				prev.vscode-marketplace.vscjava.vscode-maven
				prev.vscode-marketplace.vadimcn.vscode-lldb
				prev.vscode-marketplace.nimlang.nimlang
				prev.vscode-marketplace.cschlosser.doxdocgen
				prev.vscode-marketplace.jeff-hykin.better-cpp-syntax
				# prev.vscode-marketplace.jgclark.vscode-todo-highlight
				prev.vscode-marketplace.josetr.cmake-language-support-vscode
				
				prev.vscode-marketplace.ms-python.isort
				prev.vscode-marketplace.ms-python.vscode-pylance
				prev.vscode-marketplace.ms-vscode-remote.remote-containers
				prev.vscode-marketplace.ms-vscode-remote.remote-ssh-edit
				prev.vscode-marketplace.ms-vscode-remote.remote-wsl
				prev.vscode-marketplace.ms-vscode.cpptools-extension-pack
				prev.vscode-marketplace.ms-vscode.cpptools-themes
				prev.vscode-marketplace.ms-vscode.remote-explorer
				# https://github.com/nix-community/nix-vscode-extensions/issues/97
				prev.vscode-marketplace.ms-vsliveshare.vsliveshare
				prev.vscode-marketplace.jdinhlife.gruvbox
				#prev.vscode-marketplace.VisualStudioExptTeam.intellicode-api-usage-examples
				#prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode
				#prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-completions
				#prev.vscode-marketplace.VisualStudioExptTeam.vscodeintellicode-insiders
				prev.vscode-marketplace.vscjava.vscode-java-pack
				prev.vscode-marketplace.gruntfuggly.todo-tree
				prev.vscode-marketplace.bmalehorn.vscode-fish
				prev.vscode-marketplace.dart-code.dart-code
				prev.vscode-marketplace.dart-code.flutter
				prev.vscode-marketplace.dart-code.flutter-local-device-exposer
				prev.vscode-marketplace.elixir-tools.elixir-tools
				
				# This was confusing...
				prev.vscode-marketplace.jakebecker.elixir-ls
			] ++ 
			prev.vscode-utils.extensionsFromVscodeMarketplace [
			];
		};

		google-chrome = prev.google-chrome.override {
			commandLineArgs = "--enable-features=Vulkan,VulkanFromANGLE,TouchpadOverscrollHistoryNavigation,AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo,WaylandLinuxDrmSyncobj,WaylandPerSurfaceScale,WaylandTextInputV3,WaylandUiScale --disable-font-subpixel-positioning=true --enable-zero-copy=true --use-vulkan=true --enable-hardware-overlays=true";
			# commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo,WaylandLinuxDrmSyncobj,WaylandPerSurfaceScale,WaylandTextInputV3,WaylandUiScale --disable-font-subpixel-positioning=true --enable-zero-copy=true";
		};
		obs-studio-with-plugins = prev.wrapOBS {
			plugins = with prev.obs-studio-plugins; [
				obs-vkcapture
				obs-vaapi
			];
		};
		octaveFull = prev.octaveFull.withPackages (prev: with prev; [
			symbolic
		]);
		winetricks = prev.winetricks.overrideAttrs (old: {
			patches = [ ./patches/winetricks-fix.patch ];
		});
});
in appsOverlay
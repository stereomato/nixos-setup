{ config, pkgs, ... }:{
	users.users.stereomato.packages = with pkgs; [
		
		# General multimedia tools
		# handbrake: https://github.com/NixOS/nixpkgs/pull/297984
		mediainfo ffmpeg-fuller #handbrake-stereomato
		
		# Screen/Video recorders
		obs-studio-with-plugins simplescreenrecorder 

		# Video Production & manipulation
		kdePackages.kdenlive mkvtoolnix pitivi olive-editor flowblade
		# davinci-resolve don't use it

		# Music/Audio file management
		# Adding both normal ffmpeg and ffmpeg_5 because at time of writing (14-oct-22) default ffmpeg is 4.4.2
		# Deleted freac because it's broken anywayo
		wavpack fdk-aac-encoder lame flac opusTools opustags easytag spek # flacon

		# Music production: DAWs
		audacity qpwgraph reaper ardour # https://nixpk.gs/pr-tracker.html?pr=369048

		# Music production: plugins
		# FTBFS: distrho
		dragonfly-reverb lsp-plugins x42-plugins chowmatrix auburn-sounds-graillon-2 tal-reverb-4 calf CHOWTapeModel zam-plugins gxplugins-lv2 tap-plugins

		# Image creation and manipulation
		# imagemagickBig is the one that includes ghostscript

		gimp imagemagickBig waifu2x-converter-cpp krita

		# Image encoders
		libjxl libavif

		# FTBFS: nix log /nix/store/r3yc4j7a5yrzj5d6hvgz762r52w6b3mz-Real-ESRGAN-ncnn-vulkan-0.2.0.drv
		#realesrgan-ncnn-vulkan 


		# Tag manupulation
		# kid3
	] ++ lib.optionals config.services.desktopManager.plasma6.enable []
	++ lib.optionals config.services.xserver.desktopManager.gnome.enable [
		drawing
		gnome-obfuscate eyedropper
		kooha
	];

}

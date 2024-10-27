{ pkgs, ... }:{
	home.packages = with pkgs; [
		
		# General multimedia tools
		# handbrake: https://github.com/NixOS/nixpkgs/pull/297984
		mediainfo ffmpeg-fuller # handbrake-stereomato
		
		# Screen/Video recorders
		obs-studio-with-plugins simplescreenrecorder 
		# kooha
		# Video Production & manipulation
		kdenlive mkvtoolnix davinci-resolve pitivi olive-editor flowblade

		# Music/Audio file management
		# Adding both normal ffmpeg and ffmpeg_5 because at time of writing (14-oct-22) default ffmpeg is 4.4.2
		wavpack fdk-aac-encoder lame flac freac opusTools opustags flacon easytag spek

		# Music production: DAWs
		audacity ardour qpwgraph reaper 

		# Music production: plugins
		# FTBFS: distrho
		dragonfly-reverb lsp-plugins x42-plugins chowmatrix auburn-sounds-graillon-2 tal-reverb-4 calf CHOWTapeModel zam-plugins gxplugins-lv2 tap-plugins

		# Image creation and manipulation
		# imagemagickBig is the one that includes ghostscript
		# drawing
		gimp imagemagickBig waifu2x-converter-cpp krita

		# Image encoders
		libjxl libavif

		# FTBFS: nix log /nix/store/r3yc4j7a5yrzj5d6hvgz762r52w6b3mz-Real-ESRGAN-ncnn-vulkan-0.2.0.drv
		#realesrgan-ncnn-vulkan 
		# gnome-obfuscate eyedropper
	];
}

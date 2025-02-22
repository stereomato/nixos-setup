{ pkgs, ... }:{
	users.users.stereomato.packages = with pkgs; [
		
		# General multimedia tools
		mediainfo ffmpeg-fuller handbrake-stereomato
		
		# Screen/Video recorders
		obs-studio-with-plugins

		# Video Production & manipulation
		mkvtoolnix 

		# Music/Audio file management
		wavpack fdk-aac-encoder lame flac opusTools opustags easytag spek flacon

		# Music production: DAWs
		audacity qpwgraph reaper ardour

		# Music production: plugins
		distrho-ports dragonfly-reverb lsp-plugins x42-plugins chowmatrix auburn-sounds-graillon-2 tal-reverb-4 calf CHOWTapeModel zam-plugins gxplugins-lv2 tap-plugins

		# Images
		gimp imagemagickBig waifu2x-converter-cpp krita libjxl libavif upscaler
	];
}

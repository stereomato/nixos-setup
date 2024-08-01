{ pkgs, ... }:{
	programs.mpv = {
		enable = true;
		config = {
			# Save position on quit
			save-position-on-quit = true;

			# Video
			vo = "dmabuf-wayland";
			hwdec = true;
			hwdec-codecs = "all";
			gpu-context = "auto";
			gpu-api = "vulkan";
			# GPU shader cache will be enabled by default on mpv 0.36, but I'm on 0.35 atm.
			gpu-shader-cache = true;
			gpu-shader-cache-folder = "~/.cache/mpv";
			# Likes to crash
			vf="scale_vaapi=mode=hq:force_original_aspect_ratio=decrease:format=p010";
			#blend-subtitles=true; # Enabling raises gpu usage considerably.
			deinterlace = "no"; # it's a default, but just in case
			#video-unscaled=true; # force vaapi scaling
			# gpu-next sets these to scalers that use too much power
			# and I already use vaapi scaling
			scale = "bilinear";
			#cscale="spline36";
			dscale = "bilinear";
			# The 3 following options are too much for when on battery, especially when using fractional scaling with the current upscale to 2x then downscale method.
			#linear-downscaling=true;
			# gpu-next enables these, too much power usage imo
			correct-downscaling = false;
			sigmoid-upscaling = false;
			# Interpolation is way too expensive on a intel iris xe graphics igpu
			tscale = "oversample";
			interpolation = true; # raises it a lil, least so far
			#video-sync = "display-resample"; # raises gpu usage a bit
			#video-sync-max-video-change = "5";
			opengl-pbo = true; # decreases gpu usage
			dither-depth = "auto";
			dither = "fruit"; # default
			deband = "no";
			deband-iterations = "2";
			deband-threshold = "24";
			deband-range = "8";
			deband-grain = "24";
			vulkan-async-compute = "yes"; # intel laptop igpus only have 1 queue
			vulkan-async-transfer = "yes"; # so this setting does nothing, but leave it on for the future
			vulkan-queue-count = "1"; # tfw only 1 queue

			# Colors
			gamut-mapping-mode = "saturation";
			libplacebo-opts-append="gamut_expansion=yes";
			target-colorspace-hint = "yes";
			# target-prim = "auto"; # default
			# target-trc = "auto"; # default
			tone-mapping = "hable";
			hdr-compute-peak = "auto"; # intel gpu bug, value should be no
			hdr-contrast-recovery = "0.5"; # new default when using gpu-hq

			# Audio
			#audio-swresample-o = "resampler=soxr,cutoff=0,matrix_encoding=dplii,cheby=1,precision=33,dither_method=improved_e_weighted";
			replaygain = "album";
			gapless-audio = true;
			audio-normalize-downmix = true;

			# Subtitles
			sub-auto = "fuzzy";
			sub-bold = true;
			sub-font = "monospace";

			# Screenshots
			screenshot-tag-colorspace = true;
			screenshot-high-bit-depth = true;
			screenshot-jpeg-quality = "100";
			screenshot-template = "%F-%P";

			# Inferface
			term-osd-bar = true;
			osd-fractions = "";
			image-display-duration = "5";
			osd-font-size = "30";
			osd-font = "system-uia";

			# Cache
			cache = true;
			cache-secs = "120";

			# yt-dlp
			#script-opts = "ytdl_hook-ytdl_path = yt-dlp";
			# Set maximum resolution to 1440p.
			# Good enough bitrate.
			ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
			ytdl-raw-options = "no-sponsorblock=,downloader=aria2c,downloader-args=aria2c:'-x 10'";
		};
		bindings = {
			RIGHT = "seek 5";
			LEFT = "seek -5";
			UP = "add volume 5";
			DOWN = "add volume -5";
			KP6 = "add speed 0.25";
			KP5 = "set speed 1";
			KP4 = "add speed -0.25";
		};
		scripts  = with pkgs.mpvScripts; [
			mpris
			# https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3145
			# inhibit-gnome
			uosc
			thumbfast
		];
	};
}

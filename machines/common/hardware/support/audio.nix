{config, lib, pkgs, ...}:{
  services = {
		pulseaudio.enable = false; # because of pipewire
    # Audio + Video backend server
		# Also important for pro audio
		pipewire = {
			enable = true;
			audio.enable = true;
			alsa = {
				enable = true;
			};
			extraConfig.pipewire = {
				"10-reasonable-quantum" = {
					"context.properties" = {
						# This should be enough, in theory
						"default.clock.min-quantum" = 512;
					};
				};
			};
			pulse.enable = true;
			jack.enable = true;
		};
		
		udev.extraRules = ''
			# This is for real time audio
			KERNEL=="cpu_dma_latency", GROUP="audio"
			KERNEL=="rtc0", GROUP="audio"
			KERNEL=="hpet", GROUP="audio"
		'';
  };
	
	security = {
		rtkit.enable = true; # for pipewire
		pam = {
			# Limits needed for pro audio
			loginLimits = [
				{
					domain = "@audio";
					type = "-";
					item = "rtprio";
					value = 98;
				}
				{
					domain = "@audio";
					type = "-";
					item = "memlock";
					value = "unlimited";
				}
				{
					domain = "@audio";
					type = "-";
					item = "nice";
					value = -11;
				}
			];
		};
	};
}
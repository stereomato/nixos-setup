{config, lib, pkgs, ...}:{
  hardware.pulseaudio.enable = false; # because of pipewire
  services = {
    # Audio + Video backend server
		# Also important for pro audio
		pipewire = {
			enable = true;
			audio.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
			pulse.enable = true;
			jack.enable = true;
		};
  };
  security.rtkit.enable = true; # for pipewire
}
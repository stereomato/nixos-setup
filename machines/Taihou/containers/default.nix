{lib, pkgs, ...}:{
	virtualisation.oci-containers.containers = {
		ollama-intel = {
			# TODO: evaluate buildImage vs buildStreamedImage
			imageFile = ./ollama-intel.nix;
			volumes = [
				"ollama-volume:/root/.ollama"
			];
			ports = [
				"127.0.0.1:11434:11434"
			];
			devices = [
				"/dev/dri:/dev/dri"
			];
		};
	};
}
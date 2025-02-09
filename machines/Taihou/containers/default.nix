{lib, pkgs, ...}:{
	virtualisation.oci-containers.containers = {
		ollama-intel = {
			# TODO: evaluate buildImage vs buildStreamedImage
			# WHY DO I HAVE TO DO this?
			image = "ollama-intel:latest";
			imageFile = pkgs.callPackage ./ollama-intel.nix {};
			volumes = [
				"ollama-volume:/root/.ollama"
			];
			ports = [
				"127.0.0.1:11434:11434"
			];
			devices = [
				"/dev/dri:/dev/dri"
			];
			# networks = [ "host" ];

			# entrypoint = "/usr/share/lib/serve.sh";
		};
	};
}
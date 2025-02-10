{lib, pkgs, ...}:{
	# https://github.com/NixOS/nixpkgs/issues/298165
	networking.firewall.checkReversePath = false;

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

		open-webui = {
			image = "ghcr.io/open-webui/open-webui:latest";

			volumes = [ "open-webui-volume:/app/backend/data" ];

			dependsOn = [ "ollama-intel" ];
			ports = [ "127.0.0.1:3000:8080" ];
			environment = {
				WEBUI_AUTH = "False";
				ENABLE_OPENAI_API = "False";
				ENABLE_OLLAMA_API = "True";
			};
			extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];
		};
	};
}
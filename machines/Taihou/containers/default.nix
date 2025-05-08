{inputs, lib, pkgs, ...}:{
	# https://github.com/NixOS/nixpkgs/issues/298165
	networking.firewall.checkReversePath = false;

	virtualisation.docker = {
		storageDriver = "btrfs";
		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};

	# TODO: This is historic, essentially
	virtualisation.oci-containers.containers = {
	# 	# ollama-intel = {
	# 	# 	# TODO: evaluate buildImage vs buildStreamedImage
	# 	# 	# WHY DO I HAVE TO DO this?
	# 	# 	image = "ollama-intel:latest";
	# 	# 	imageFile = pkgs.callPackage ./ollama-intel.nix {};
	# 	# 	workdir = "/llm/scripts";
	# 	# 	volumes = [
	# 	# 		"/tmp/.X11-unix:/tmp/.X11-unix"
	# 	# 		"ollama-volume:/root/.ollama"
	# 	# 	];
	# 	# 	environment = {
	# 	# 		DISPLAY = ":0";
	# 	# 		Device = "iGPU";
	# 	# 	};
	# 	# 	ports = [
	# 	# 		"127.0.0.1:11434:11434"
	# 	# 	];
	# 	# 	devices = [
	# 	# 		"/dev/dri:/dev/dri"
	# 	# 	];
	# 	# 	# networks = [ "host" ];

	# 	# 	# entrypoint = "/usr/share/lib/serve.sh";
	# 	# };

	# 	# # ipex-llm-inference = {
	# 	# # 	image = "intelanalytics/ipex-llm-inference-cpp-xpu:latest";
	# 	# # 	ports = [
	# 	# # 		"127.0.0.1:11434:11434"
	# 	# # 	];
	# 	# # 	devices = [
	# 	# # 		"/dev/dri:/dev/dri"
	# 	# # 	];
	# 	# # };


		
	# 	# ollama-intel-arc = {
	# 	# 	image = "localhost/ollama-intel-arc:latest";
	# 	# 	volumes = [
	# 	# 		"ollama-volume:/root/.ollama"
	# 	# 	];
	# 	# 	environment = {
	# 	# 		Device = "iGPU";
	# 	# 	};
	# 	# 	ports = [
	# 	# 		"127.0.0.1:11434:11434"
	# 	# 	];
	# 	# 	devices = [
	# 	# 		"/dev/dri:/dev/dri"
	# 	# 	];
	# 	# 	# networks = [ "host" ];

	# 	# 	# entrypoint = "/usr/share/lib/serve.sh";
	# 	# };

		open-webui = {
			# TODO: https://github.com/open-webui/open-webui/discussions/8999
			image = "ghcr.io/open-webui/open-webui:v0.6.5";
			volumes = [ "open-webui-volume:/app/backend/data" ];

	 		# dependsOn = [ "ollama-intel" ];
			ports = [ "127.0.0.1:3000:8080" ];
			# TODO: This is annoying
			environment = {
				WEBUI_AUTH = "False";
				ENABLE_OPENAI_API = "False";
				ENABLE_OLLAMA_API = "True";
				OLLAMA_BASE_URL = "http://127.0.0.1:11434";
			};
	 		extraOptions = [ "--network=host" ];
		};
	};

	# This uses localhost/ollama-intel-arc:latest because this is locally built
	# to circumvent the fact that I can't build a docker image like ollama-intel-arc
	# using NixOS' docker module.
	# See README.md for more details.
}

{
	pkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:let
	serve = pkgs.stdenvNoCC.mkDerivation {
		pname = "serve-for-ollama-intel";
		version = "1";

		src = serve-script;
		dontUnpack = true;

		installPhase = ''
			mkdir -p $out/usr/share/lib
			cp $src $out/usr/share/lib/serve.sh

			chmod +x $out/usr/share/lib/serve.sh
		'';
	};
	
	serve-script = pkgs.writers.writeText "serve.sh" ''
		#!/bin/bash

		FILE="/intel-setup-done"

		# Check if the file does not exist or does not contain "1"
		if [[ ! -f "$FILE" || "$(cat "$FILE")" != "1" ]]; then
			echo "File is missing or does not contain '1'. Running setup..."
			intel-support-setup.sh
			# exit 1
		fi

		# echo "File exists and contains '1'. Continuing..."

		source /opt/intel/oneapi/setvars.sh
		export USE_XETLA=OFF
		export ZES_ENABLE_SYSMAN=1
		export SYCL_CACHE_PERSISTENT=1
		export SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
		export ONEAPI_DEVICE_SELECTOR=level_zero:0
		/usr/local/lib/python3.12/dist-packages/bigdl/cpp/libs/ollama serve
	'';

	intel-support-setup = pkgs.stdenvNoCC.mkDerivation {
		pname = "intel-support-setup";
		version = "1";

		src = intel-support-setup-script;
		dontUnpack = true;

		installPhase = ''
			mkdir -p $out/usr/local/bin
			cp $src $out/usr/local/bin/intel-support-setup.sh

			chmod +x $out/usr/local/bin/intel-support-setup.sh
		'';
	};
	
	intel-support-setup-script = pkgs.writers.writeText "intel-support-setup.sh" ''
		#!/bin/bash
		# Base packages
		apt update
		apt install --no-install-recommends -q -y wget gnupg ca-certificates python3-pip pkg-config build-essential python3-dev cmake

		# IPEX-LLM installation (Intel GPU support)
		wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
		echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client' | tee /etc/apt/sources.list.d/intel-gpu-jammy.list
		apt update
		apt install --no-install-recommends -q -y udev level-zero libigdgmm12 intel-level-zero-gpu intel-opencl-icd

		# oneAPI packages
		wget -qO - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor --output /usr/share/keyrings/oneapi-archive-keyring.gpg
		echo 'deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main' | tee /etc/apt/sources.list.d/oneAPI.list
		apt update

		apt install --no-install-recommends -q -y intel-oneapi-common-vars intel-oneapi-common-oneapi-vars intel-oneapi-diagnostics-utility intel-oneapi-compiler-dpcpp-cpp intel-oneapi-dpcpp-ct intel-oneapi-mkl intel-oneapi-mkl-devel intel-oneapi-mpi intel-oneapi-mpi-devel intel-oneapi-dal intel-oneapi-dal-devel intel-oneapi-ippcp intel-oneapi-ippcp-devel intel-oneapi-ipp intel-oneapi-ipp-devel intel-oneapi-tlt intel-oneapi-ccl intel-oneapi-ccl-devel intel-oneapi-dnnl-devel intel-oneapi-dnnl intel-oneapi-tcm-1.0

		# Install ipex-llm[cpp] using pip
		pip install --pre --upgrade ipex-llm[cpp]

		# Mark as done
		echo 1 | tee /intel-setup-done
	'';
	
	ubuntu-image = pkgs.dockerTools.pullImage {
		imageName = "ubuntu";
		imageDigest = "sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782";
		hash = "sha256-yp5atGz1qYMTsej9N1O5h4OKcRC5iPQrBhNdw9TRIag=";
		finalImageName = "ubuntu";
		finalImageTag = "latest";
	};
	in
	pkgs.dockerTools.buildImage {
		name = "ollama-intel";
		tag = "latest";
		fromImage = ubuntu-image;

		# runAsRoot = "
		# 	# Base packages
		# 	apt update
		# 	apt install --no-install-recommends -q -y wget gnupg ca-certificates python3-pip pkg-config build-essential python3-dev cmake

		# 	# IPEX-LLM installation (Intel GPU support)
		# 	wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
		# 	echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client' | tee /etc/apt/sources.list.d/intel-gpu-jammy.list
		# 	apt update
		# 	apt install --no-install-recommends -q -y udev level-zero libigdgmm12 intel-level-zero-gpu intel-opencl-icd

		# 	# oneAPI packages
		# 	wget -qO - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor --output /usr/share/keyrings/oneapi-archive-keyring.gpg
		# 	echo 'deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main' | tee /etc/apt/sources.list.d/oneAPI.list
		# 	apt update

		# 	apt install --no-install-recommends -q -y intel-oneapi-common-vars intel-oneapi-common-oneapi-vars intel-oneapi-diagnostics-utility intel-oneapi-compiler-dpcpp-cpp intel-oneapi-dpcpp-ct intel-oneapi-mkl intel-oneapi-mkl-devel intel-oneapi-mpi intel-oneapi-mpi-devel intel-oneapi-dal intel-oneapi-dal-devel intel-oneapi-ippcp intel-oneapi-ippcp-devel intel-oneapi-ipp intel-oneapi-ipp-devel intel-oneapi-tlt intel-oneapi-ccl intel-oneapi-ccl-devel intel-oneapi-dnnl-devel intel-oneapi-dnnl intel-oneapi-tcm-1.0

		# 	# Install ipex-llm[cpp] using pip
		# 	pip install --pre --upgrade ipex-llm[cpp]
		# ";

		copyToRoot = pkgs.buildEnv {
			name = "image-root";
			pathsToLink = [ "/usr" ];
			paths = [ serve intel-support-setup ];
		};

		config = {
			Entrypoint = ["/bin/bash" "/usr/share/lib/serve.sh"];
			Env = [
				"DEBIAN_FRONTEND=noninteractive"
				"PIP_BREAK_SYSTEM_PACKAGES=1"
				"OLLAMA_NUM_GPU=999"
				"OLLAMA_HOST=0.0.0.0:11434"
			];
		};
	}

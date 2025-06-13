let toolsOverlay = (final: prev: {
	intel_lpmd = prev.callPackage ../modules/pkgs/intel_lpmd.nix {};
		# Make ppd only use balance-performance
		# TODO: https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/issues/151
		power-profiles-daemon = prev.power-profiles-daemon.overrideAttrs (old: {
			patches = prev.power-profiles-daemon.patches ++ [ ./patches/ppd-intel-balance-performance.patch ];
		});
		

	threadsFile = prev.runCommandLocal "cores-for-hardware-config" {} '' 
		mkdir $out
		nproc | tr -d '\n' | tee $out/numThreads
		echo '''$(($(nproc) / 2 ))| tr -d '\n' | tee $out/halfNumThreads
	'';
	nvtop = prev.nvtop.override {
		nvidia = false;
	};

	ydotool = prev.ydotool.overrideAttrs(old: {
		src = prev.fetchFromGitHub {
			owner = "stereomato";
			repo = "ydotool";
			rev = "8e8a3d0776b59bf030c45a1458aa55473faa2400";
			hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
		};
	});
});
in toolsOverlay
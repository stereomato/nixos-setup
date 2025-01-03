{ pkgs, ... }:{
	nixpkgs.overlays = [(
			self: super: {

				# These two are self explanatory
				# Need to assign them to each thingy so that well, it'll get overriden as necessary.
				# I don't think overriding everything
				qtbase-no-stem-darkening = pkgs.kdePackages.qtbase.overrideAttrs(old: {
					patches = pkgs.kdePackages.qtbase.patches ++ [
						./patches/disable-stem-darkening.patch
					];
				});
				qt5base-no-stem-darkening = pkgs.libsForQt5.qt5.qtbase.overrideAttrs(old: {
					patches = pkgs.libsForQt5.qt5.qtbase.patches ++ [
						./patches/disable-stem-darkening-qt5.patch
					];
				});
				google-chrome = super.google-chrome.override {
					commandLineArgs = "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true --use-vulkan=true";
					# commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true";
				};

				#google-chrome = super.google-chrome.overrideAttrs (old: {
				#	buildInputs = super.google-chrome.buildInputs ++ [ super.kdePackages.full ];
				#});
				chowmatrix = super.callPackage ./derivationsYetToUpstream/chowmatrix.nix {};
				auburn-sounds-graillon-2 = super.callPackage ./derivationsYetToUpstream/auburn-sounds-graillon-2.nix {};
				tal-reverb-4 = super.callPackage ./derivationsYetToUpstream/tal-reverb-4.nix {};
				obs-studio-with-plugins = pkgs.wrapOBS {
					plugins = with pkgs.obs-studio-plugins; [
						obs-vkcapture
						obs-vaapi
					];
				};
				handbrake-stereomato = super.handbrake.override {
					useFdk = true;
				};
				ffmpeg-fuller = super.ffmpeg-full.override {
					withUnfree = true;
					# enableLto = true; # fails...
				};
				# FIXME: https://github.com/NixOS/nixpkgs/pull/294710
				gimp-stereomato = super.gimp.override {
					withPython = true;
				};
				patool = super.patool.overridePythonAttrs (old: {
					disabledTests = super.patool.disabledTests ++ [ "test_nested_gzip" ];
				});
			}
	)];
}

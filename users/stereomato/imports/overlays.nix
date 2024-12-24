{ pkgs, ... }:{
	nixpkgs.overlays = [(
			self: super: {
				google-chrome = super.google-chrome.override {
					# commandLineArgs = "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true --use-vulkan=true";
					commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true";
				};

				#google-chrome = super.google-chrome.overrideAttrs (old: {
				#	buildInputs = super.google-chrome.buildInputs ++ [ super.kdePackages.full ];
				#});
				vscode = super.vscode.override {
					commandLineArgs = "--disable-font-subpixel-positioning=true";
				};
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
			}
	)];
}

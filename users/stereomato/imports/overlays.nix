{ pkgs, ... }:{
	nixpkgs.overlays = [(
			self: super: {
				google-chrome = super.google-chrome.override {
					commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,VaapiVideoDecodeLinuxGL,ParallelDownloading --disable-font-subpixel-positioning";
				};
			vscode = super.vscode.override {
			commandLineArgs = "--disable-font-subpixel-positioning";
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
			ffmpeg-fuller = super.ffmpeg_6-full.override {
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
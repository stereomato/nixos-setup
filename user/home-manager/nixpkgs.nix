{ inputs, pkgs, ... }:
{
	nixpkgs = {
			config = {
				allowUnfree = true;
				joypixels.acceptLicense = true;
				input-fonts.acceptLicense = true;
				permittedInsecurePackages = [
					# Davinci Resolve
					"python-2.7.18.6"
					# Whalebird
					"electron-19.0.7"
					# Cinny
					"openssl-1.1.1u"
					# Find out what
					"electron-21.4.0"
				];
			};
			overlays = [(
				self: super: {
					# UGLY, see: https://github.com/NixOS/nix/pull/2911
					# Also, see: https://github.com/NixOS/nixpkgs/issues/214848
					emoji-removal = super.writeScriptBin "emoji-removal" ''
						#!/usr/bin/env -S ${super.fontforge}/bin/fontforge -lang=ff -script 
						Open($1)
						SetTTFName(0x409,13,"")
						Select(0u2600,0u26ff)
						DetachAndRemoveGlyphs()
						Generate($1)
						Select(0u2700,0u27bf)
						DetachAndRemoveGlyphs()
						Generate($1)
						Select(0u10000,0u1fffd)
						DetachAndRemoveGlyphs()
						Generate($1)
					'';
					chowmatrix = super.callPackage ./derivationsYetToUpstream/chowmatrix.nix {};
					auburn-sounds-graillon-2 = super.callPackage ./derivationsYetToUpstream/auburn-sounds-graillon-2.nix {};
					tal-reverb-4 = super.callPackage ./derivationsYetToUpstream/tal-reverb-4.nix {};
					nvtop = super.nvtop.override {
						nvidia = false;
					};
					obs-studio-with-plugins = pkgs.wrapOBS {
						plugins = with pkgs.obs-studio-plugins; [
							obs-vkcapture
							obs-vaapi
						];
					};
					handbrake-pearsche = super.handbrake.override {
						useFdk = true;
					};
					ffmpeg-fuller = super.ffmpeg_6-full.override {
						withUnfree = true;
						# enableLto = true; # fails...
					};
					firefox = super.firefox.override {
						cfg = {
							enableGnomeExtensions = true;
						};
					};
					gimp-pearsche = super.gimp-with-plugins.override {
						withPython = true;
					};
				} 
			)];
	};
}
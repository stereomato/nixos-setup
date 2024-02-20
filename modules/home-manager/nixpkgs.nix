{ pkgs, ... }:
{
	nixpkgs = {
			config = {
				allowUnfree = true;
				joypixels.acceptLicense = true;
				input-fonts.acceptLicense = true;
				permittedInsecurePackages = [
					# Bitwarden
					"electron-25.9.0"
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
					home-manager-gc-start = super.writeScriptBin "home-manager-gc-start" ''
          #!${super.bash}/bin/bash
            set -e
            exec ${super.nix}/bin/nix-collect-garbage --delete-older-than 15d					
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
					handbrake-stereomato = super.handbrake.override {
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
					gimp-stereomato = super.gimp-with-plugins.override {
						withPython = true;
					};
					# This just installs a hunspell package with these dictionaries
					# Not for *other* packages to use them...
					#hunspell-stereomato = super.hunspellWithDicts [
					#	super.hunspellDicts.en_US
					#	super.hunspellDicts.es_PE
					#];
					#python3Packages.librosa = super.python3Packages.librosa.#overrideAttrs(old: {
					#	disabledTests = super.python3Packages.librosa.disabledTests ++ "test_nnls_vector";
					#});
				}
			)];
	};
}
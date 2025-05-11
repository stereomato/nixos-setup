let fontsOverlay = (
	final: prev: {
		# UGLY, see: https://github.com/NixOS/nix/pull/2911
		# Also, see: https://github.com/NixOS/nixpkgs/issues/214848
		emoji-removal = prev.writeScriptBin "emoji-removal" ''
					#!/usr/bin/env -S ${prev.fontforge}/bin/fontforge -lang=ff -script
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
		# [buildPlans.IosevkaCustom]
		# family = "Iosevka Custom"
		# spacing = "normal"
		# serifs = "sans"
		# noCvSs = false
		# exportGlyphNames = true

		# [buildPlans.IosevkaCustom.variants.design]
		# eight = "two-circles"
		# capital-g = "toothed-serifed-hooked"
		# capital-q = "crossing-baseline"
		# f = "flat-hook-serifless"
		# g = "single-storey-flat-hook-serifless"
		# r = "serifed"
		# t = "flat-hook-short-neck2"
		# paren = "flat-arc"
		# brace = "straight"
		# guillemet = "straight"
		# at = "fourfold-solid-inner"
		# [buildPlans.IosevkaCustom.widths.Normal]
		# shape = 500
		# menu = 5
		# css = "normal"

		# [buildPlans.IosevkaCustom.widths.Extended]
		# shape = 600
		# menu = 7
		# css = "expanded"

		# [buildPlans.IosevkaCustom.widths.Condensed]
		# shape = 416
		# menu = 3
		# css = "condensed"

		# [buildPlans.IosevkaCustom.widths.SemiCondensed]
		# shape = 456
		# menu = 4
		# css = "semi-condensed"

		# [buildPlans.IosevkaCustom.widths.SemiExtended]
		# shape = 548
		# menu = 6
		# css = "semi-expanded"

		# [buildPlans.IosevkaCustom.widths.ExtraExtended]
		# shape = 658
		# menu = 8
		# css = "extra-expanded"

		# [buildPlans.IosevkaCustom.widths.UltraExtended]
		# shape = 720
		# menu = 9
		# css = "ultra-expanded"
		iosevka-stereomato = prev.iosevka.override {
			privateBuildPlan = {
				family = "stereomato's Iosevka setup";
				spacing = "normal";
				serifs = "sans";
				noCvSs = false;
				exportGlyphNames = true;
				variants = {
					design = {
						capital-g = "toothed-serifless-hooked";
						capital-j = "serifed";
						capital-q = "crossing-baseline";
						f = "flat-hook-serifless";
						g = "single-storey-flat-hook-serifless";
						r = "serifed";
						t = "flat-hook-short-neck2";
						eight = "two-circles";
						at = "fourfold-solid-inner";
						paren = "flat-arc";
						brace = "straight";
						guillemet = "straight";
					};
				};
				widths.normal = {
					shape = 500;
					menu = 5;
					css = "normal";
				};
				widths.extended = {
					shape = 600;
					menu = 7;
					css = "expanded";
				};
				widths.condensed = {
					shape = 416;
					menu = 3;
					css = "condensed";
				};
				widths.semicondensed = {
					shape = 456;
					menu = 4;
					css = "semi-condensed";
				};
				widths.semiextended = {
					shape = 548;
					menu = 6;
					css = "semi-expanded";
				};
				widths.extraextended = {
					shape = 658;
					menu = 8;
					css = "extra-expanded";
				};
				widths.ultraextended = {
					shape = 720;
					menu = 9;
					css = "ultra-expanded";
				};
			};
			set = "Iosevka-stereomato";
		};
		SF-Pro = prev.callPackage ./localDerivations/SF-Pro.nix {};
		SF-Compact = prev.callPackage ./localDerivations/SF-Compact.nix {};
		SF-Mono = prev.callPackage ./localDerivations/SF-Mono.nix {};
		SF-Arabic = prev.callPackage ./localDerivations/SF-Arabic.nix {};
		New-York = prev.callPackage ./localDerivations/New-York.nix {};
		Bitter-Pro = prev.callPackage ./localDerivations/Bitter-Pro.nix {};
		Playfair-Display = prev.callPackage ./localDerivations/Playfair-Display.nix {};
		ANRT-Baskervville = prev.callPackage ./localDerivations/ANRT-Baskervville.nix {};
		input-fonts = prev.input-fonts.overrideAttrs (old: {
			pname = "${prev.input-fonts.pname}";
			version = "${prev.input-fonts.version}";
			src =
				prev.fetchzip {
					name = "${prev.input-fonts.pname}-${prev.input-fonts.version}";
					url = "https://input.djr.com/build/?fontSelection=whole&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email=&.zip";
					hash = "sha256-Rfd8jM3rPuPeGEZWKfczX7IfHwWHyJNfGEDOkJ/aenY=";
					stripRoot = false;
				};
		});

		# Overlay to make jetbrains mono install the variable font only
		jetbrains-mono-variable = prev.jetbrains-mono.overrideAttrs (old: {
			# From the original, here I only remove the line that installs the non-variable font files
			installPhase = ''
				runHook preInstall
				install -Dm644 -t $out/share/fonts/truetype/ fonts/variable/*.ttf
				runHook postInstall
			'';
		});

		commit-mono-stereomato-script = prev.writers.writeFishBin "cmsc" ''
			set -l options 'srcPath=' 'localPath=' 'fontFormat='
			argparse $options -- $argv

			set command ${prev.python3Packages.opentype-feature-freezer}/bin/pyftfeatfreeze

			for font in "$_flag_srcPath"/*."$_flag_fontFormat"
				# This enables those flags, and gets the font filename (without the .otf) to save the font file
				$command -f 'ss03,ss04,ss05,cv02,cv06,cv10' -S -U Stereomato -R 'CommitMonoV143/CommitMono' $font "$_flag_localPath"/(string replace .otf "" (string replace "$_flag_srcPath" "" $font))-Stereomato."$_flag_fontFormat"
				
				# Delete the original fonts
				rm $_flag_localPath/(string replace "$_flag_srcPath" "" $font)
			end
		'';

		commit-mono-stereomato = prev.callPackage ./localDerivations/commit-mono-stereomato.nix {};


		# prev.commit-mono.overrideAttrs(old: {
		#   postInstall = ''
		#     ${prev.commit-mono-stereomato-script}/bin/cmsc
		#   '';
		# });


		# This is so that the Inter variant I use is the otf one
		# because KDE/QT do stem darkening on OTF fonts only.
		inter-otf = prev.inter.overrideAttrs (old: {
			pname = "inter-otf";
			installPhase = ''
				runHook preInstall

				mkdir -p $out/share/fonts/otf
				cp extras/otf/*.otf $out/share/fonts/otf

				runHook postInstall
			'';
		});
	}
);
in fontsOverlay
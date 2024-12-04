{ pkgs, ... }:{

	nixpkgs.overlays = [(
		self: super: {
			iosevka-stereomato = super.iosevka.override {
				privateBuildPlan = {
					family = "stereomato's Iosevka setup";
					spacing = "normal";
					serifs = "sans";
					no-cv-ss = false;
					export-glyph-names = true;
					no-ligation = true;
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
			SF-Pro = super.callPackage ./derivationsYetToUpstream/SF-Pro.nix {};
			SF-Compact = super.callPackage ./derivationsYetToUpstream/SF-Compact.nix {};
			SF-Mono = super.callPackage ./derivationsYetToUpstream/SF-Mono.nix {};
			SF-Arabic = super.callPackage ./derivationsYetToUpstream/SF-Arabic.nix {};
			New-York = super.callPackage ./derivationsYetToUpstream/New-York.nix {};
			Bitter-Pro = super.callPackage ./derivationsYetToUpstream/Bitter-Pro.nix {};
			Playfair-Display = super.callPackage ./derivationsYetToUpstream/Playfair-Display.nix {};
			ANRT-Baskervville = super.callPackage ./derivationsYetToUpstream/ANRT-Baskervville.nix {};
			input-fonts = super.input-fonts.overrideAttrs (old: {
				pname = "${super.input-fonts.pname}";
				version = "${super.input-fonts.version}";
				src =
					super.fetchzip {
						name = "${super.input-fonts.pname}-${super.input-fonts.version}";
						url = "https://input.djr.com/build/?fontSelection=whole&a=0&g=ss&i=serif&l=serif&zero=slash&asterisk=0&braces=straight&preset=default&line-height=1.2&accept=I+do&email=&.zip";
						sha256 = "0sjq478azj93267lzm737fcjaxaddlbh48pq97cnbm3wslqb2rcy";
						stripRoot = false;
					};
			});
			
			# Overlay to make jetbrains mono install the variable font only
			jetbrains-mono-variable = super.jetbrains-mono.overrideAttrs (old: {
				# From the original, here I only remove the line that installs the non-variable font files
				installPhase = ''
					runHook preInstall
					install -Dm644 -t $out/share/fonts/truetype/ fonts/variable/*.ttf
					runHook postInstall
				'';
			});

			# This is so that the Inter variant I use is the otf one
			# because KDE/QT do stem darkening on OTF fonts only.
			inter-otf = super.inter.overrideAttrs (old: {
				pname = "inter-otf";
				installPhase = ''
					runHook preInstall

					mkdir -p $out/share/fonts/otf
					cp extras/otf/*.otf $out/share/fonts/otf

					runHook postInstall
				'';
			});
		}
	)];
	fonts = {
		#TODO: find out a way to not install freefont_ttf (gnu free fonts)
		# (because of the braille font being butt ugly)
		# I could just add a fontconfig rule to put freemono really low but eh
		enableDefaultPackages = false;
		packages = with pkgs; [

			anonymousPro
			Bitter-Pro
			noto-fonts
			noto-fonts-extra
			# noto-fonts-emoji
			noto-fonts-emoji-blob-bin
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			cascadia-code
			fira
			fira-mono
			fira-code
			# joypixels
			ibm-plex
			#iosevka-stereomato
			manrope
			roboto
			roboto-slab
			roboto-mono
			jetbrains-mono-variable
			# input-fonts
			inter
			# inter-otf
			source-sans
			source-serif
			source-code-pro
			source-han-sans
			source-han-mono
			source-han-serif
			source-han-code-jp
			victor-mono
			inconsolata
			courier-prime
			pretendard
			pretendard-jp
			pretendard-std
			ia-writer-duospace
			Playfair-Display
			ANRT-Baskervville
			terminus_font_ttf
			terminus_font
			commit-mono
		]; 
		fontDir.enable = true;
		fontconfig = {
			cache32Bit = true;
			useEmbeddedBitmaps = false;
			subpixel = {
				rgba = "none";
				lcdfilter = "none";
			};
			hinting = {
				enable = false;
				style = "none";
				autohint = false;
			};
			localConf = ''
				<fontconfig>
				<alias>
					<family>system-ui</family>
					<prefer>
						<family>Inter Variable</family>
						<family>Cantarell</family>
					</prefer>
				</alias>

				<match target="font">
					<test name="family" compare="eq" ignore-blanks="true">
						<string>CommitMono</string>
					</test>
					<edit name="fontfeatures" mode="append">
						<string>ss03 on</string> <!-- Smart case -->
						<string>ss04 on</string> <!-- Symbol spacing -->
						<string>ss05 on</string> <!-- Smart kerning -->
						<string>cv02 on</string> <!-- Alt g -->
						<string>cv06 on</string> <!-- Alt 6/9 -->
						<string>cv10 on</string> <!-- Alt l -->
					</edit>
				</match>

				</fontconfig>
			'';
			# Do I even need this? 
			#<match target="font">
			#		<edit name="dpi" mode="assign" binding="strong">
			#			<double>141.0</double>
			#		</edit>
			#	</match>
				
			defaultFonts = {
				sansSerif = [ 
					# "Inter"
					"Inter Variable"
					"Cantarell"
				];
				serif = [ "Roboto Slab" ];
				monospace = [ "Jetbrains Mono" ];
				emoji = [ "Blobmoji" ];
			};
		};
	};
	# MacOS-like font rendering
	# Font emboldering
	# FREETYPE_PROPERTIES="cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0 autofitter:no-stem-darkening=0";
	
	# fuzziness a la macOS/W95
	environment.variables = {
		FREETYPE_PROPERTIES = "truetype:interpreter-version=35";
	};
}

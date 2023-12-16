{ pkgs, ... }:{
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
			#iosevka-pearsche
			manrope
			roboto
			roboto-slab
			roboto-mono
			jetbrains-mono
			input-fonts
			inter
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
						<family>Inter Display</family>
						<family>Cantarell</family>
					</prefer>
				</alias>
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
					"Inter" 
					"Cantarell"
				];
				serif = [ "Roboto Slab" ];
				monospace = [ "Input Mono" ];
				emoji = [ "Blobmoji" ];
			};
		};
	};
}

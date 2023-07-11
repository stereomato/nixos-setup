{ lib, pkgs, ... }:{
	fonts = {
		fonts = with pkgs; [
			Bitter-Pro
			noto-fonts
			noto-fonts-extra
			noto-fonts-emoji
			noto-fonts-emoji-blob-bin
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			cascadia-code
			fira
			fira-mono
			fira-code
			joypixels
			ibm-plex
			#iosevka-pearsche
			manrope
			roboto
			roboto-slab
			roboto-mono
			jetbrains-mono
			#input-fonts
			#Input-Fonts-Custom
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
			};
			localConf = ''
				<fontconfig>
				<alias>
					<family>system-ui</family>
					<prefer>
						<family>Inter</family>
						<family>Cantarell</family>
					</prefer>
				</alias>
				<match target="font">
					<edit name="dpi" mode="assign" binding="strong">
						<double>141.0</double>
					</edit>
					<edit name="autohint" mode="assign" binding="strong">
      			<bool>false</bool>
    			</edit>
				</match>
				
				</fontconfig>
			'';
			defaultFonts = {
				sansSerif = [ 
					"Inter" 
					"Cantarell"
				];
				serif = [ "Bitter Pro" ];
				monospace = [ "Jetbrains Mono NL" ];
				emoji = [ "Blobmoji" ];
			};
		};
	};
}

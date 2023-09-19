{ 
	lib
,	fetchurl
, writeScript
, stdenv
,	p7zip
#,	emoji-removal
}:

stdenv.mkDerivation rec {
	actualName = "SF-Mono";
	# Cant use this, but asked about it on reddit and telegram...
	#specialHandlingBits = {
	#	a = "SF";
	#	b = "Mono";
	#	c = "Fonts";
	#};

	# Use this instead 
	specialHandlingBit1 = "SF";
	specialHandlingBit2 = "Mono";
	specialHandlingBit3 = "Fonts";

# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "${actualName}";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "7";

	src = fetchurl {
		url = https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg;
		sha256 = "0fdcras7y7cvym6ahhgn7ih3yfkkhr9s6h5b6wcaw5svrmi6vbxb";
	};

	nativeBuildInputs = [
		p7zip
	#	emoji-removal
	];

	unpackCmd = "7z x $curSrc";
	phases = "unpackPhase installPhase fixupPhase";

	installPhase = ''
		7z x "${specialHandlingBit1} ${specialHandlingBit2} ${specialHandlingBit3}.pkg"
		7z x Payload~
		# Doesn't work due to the script bug...
		#find . -name \*.otf -execdir emoji-removal {} \;
		mkdir -p $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3}
		find . -name \*.otf -execdir mv {} $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3} \;
	'';
		
	meta = with lib; {
		homepage = "https://developer.apple.com/fonts/";
		description = "This monospaced variant of San Francisco enables alignment between rows and columns of text, and is used in coding environments like Xcode. SF Mono features six weights and supports Latin, Greek, and Cyrillic scripts.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
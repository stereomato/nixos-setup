{ 
	lib
,	fetchurl
, writeScript
, stdenv
,	p7zip
#,	emoji-removal
}:

stdenv.mkDerivation rec {
	actualName = "SF-Arabic";
	# Cant use this, but asked about it on reddit and telegram...
	#specialHandlingBits = {
	#	a = "SF";
	#	b = "Mono";
	#	c = "Fonts";
	#};

	# Use this instead 
	specialHandlingBit1 = "SF";
	specialHandlingBit2 = "Arabic";
	specialHandlingBit3 = "Fonts";

# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "${actualName}";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "1";

	src = fetchurl {
		url = https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg;
		sha256 = "0habrwbdsffkg2dnnawna8w93psc2n383hyzvsxn3a5n7ai63mp2";
	};

	nativeBuildInputs = [
		p7zip
	#	emoji-removal
	];

	unpackCmd = "7z x $curSrc";
	phases = "unpackPhase installPhase fixupPhase";

	installPhase = ''
		echo
		7z x "${specialHandlingBit1} ${specialHandlingBit2} ${specialHandlingBit3}.pkg"
		7z x Payload~
		# Doesn't work due to the script bug...
		#find . -name \*.ttf -execdir emoji-removal {} \;
		mkdir -p $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3}
		find . -name \*.ttf -execdir mv {} $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3} \;
	'';
		
	meta = with lib; {
		homepage = "https://developer.apple.com/fonts/";
		description = "A contemporary interpretation of the Naskh style with a rational and flexible design, this extension of San Francisco is the Arabic system font on Apple platforms. Like San Francisco, SF Arabic features nine weights, variable optical sizes that automatically adjust spacing and contrast based on the point size, and includes a rounded variant.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
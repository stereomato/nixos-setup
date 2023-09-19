{ 
	lib
,	fetchurl
,	writeScript
,	stdenv
,	p7zip
#,	emoji-removal
}:

stdenv.mkDerivation rec {
	actualName = "SF-Pro";
	# Cant use this, but asked about it on reddit and telegram...
	#specialHandlingBits = {
	#	a = "SF";
	#	b = "Mono";
	#	c = "Fonts";
	#};

	# Use this instead 
	specialHandlingBit1 = "SF";
	specialHandlingBit2 = "Pro";
	specialHandlingBit3 = "Fonts";

# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "${actualName}";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "1";

	src = fetchurl {
		url = https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg;
		sha256 = "0z3cbaq9dk8dagjh3wy20cl2j48lqdn9q67lbqmrrkckiahr1xw3";
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
		#find . -name \*.otf -execdir emoji-removal {} \;
		mkdir -p $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3}
		find . -name \*.otf -execdir mv {} $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3} \;
	'';
		
	meta = with lib; {
		homepage = "https://developer.apple.com/fonts/";
		description = "This neutral, flexible, sans-serif typeface is the system font for iOS, iPad OS, macOS and tvOS. SF Pro features nine weights, variable optical sizes for optimal legibility, four widths, and includes a rounded variant. SF Pro supports over 150 languages across Latin, Greek, and Cyrillic scripts.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
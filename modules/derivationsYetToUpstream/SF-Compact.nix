{ 
	lib
,	fetchurl
, writeScript
, stdenv
,	p7zip
#,	emoji-removal
}:

stdenv.mkDerivation rec {
	actualName = "SF-Compact";
	# Cant use this, but asked about it on reddit and telegram...
	#specialHandlingBits = {
	#	a = "SF";
	#	b = "Mono";
	#	c = "Fonts";
	#};

	# Use this instead 
	specialHandlingBit1 = "SF";
	specialHandlingBit2 = "Compact";
	specialHandlingBit3 = "Fonts";

# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "${actualName}";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "1";

	src = fetchurl {
		url = https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg;
		sha256 = "04sq98pldn9q1a1npl6b64karc2228zgjj4xvi6icjzvn5viqrfj";
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
		find . -name \*.otf -execdir mv {} $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3}/ \;
	'';
		
	meta = with lib; {
		homepage = "https://developer.apple.com/fonts/";
		description = "Sharing many features with SF Pro, SF Compact features an efficient, compact design that is optimized for small sizes and narrow columns. SF Compact is the system font for watchOS and includes a rounded variant.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
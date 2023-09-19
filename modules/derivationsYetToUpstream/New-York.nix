{ 
	lib
,	fetchurl
, writeScript
, stdenv
,	p7zip
#,	emoji-removal
}:

stdenv.mkDerivation rec {
	actualName = "New-York";
	# Cant use this, but asked about it on reddit and telegram...
	#specialHandlingBits = {
	#	a = "SF";
	#	b = "Mono";
	#	c = "Fonts";
	#};

	# Use this instead 
	specialHandlingBit1 = "N";
	specialHandlingBit2 = "Y";
	specialHandlingBit3 = "Fonts";

# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "${actualName}";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "6";

	src = fetchurl {
		url = https://devimages-cdn.apple.com/design/resources/download/NY.dmg;
		sha256 = "1q0b741qiwv5305sm3scd9z2m91gdyaqzr4bd2z54rvy734j1q0y";
	};

	nativeBuildInputs = [
		p7zip
	#	emoji-removal
	];

	unpackCmd = "7z x $curSrc";
	phases = "unpackPhase installPhase fixupPhase";

	installPhase = ''
		7z x "${specialHandlingBit1}${specialHandlingBit2} ${specialHandlingBit3}.pkg"
		7z x Payload~
		# Doesn't work due to the script bug...
		#find . -name \*.otf -execdir emoji-removal {} \;
		mkdir -p $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3}
		find . -name \*.otf -execdir mv {} $out/share/fonts/${specialHandlingBit1}${specialHandlingBit2}${specialHandlingBit3} \;
	'';
		
	meta = with lib; {
		homepage = "https://developer.apple.com/fonts/";
		description = "A companion to San Francisco, this serif typeface is based on essential aspects of historical type styles. New York features six weights, supports Latin, Greek and Cyrillic scripts, and features variable optical sizes allowing it to perform as a traditional reading face at small sizes and a graphic display face at larger sizes.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
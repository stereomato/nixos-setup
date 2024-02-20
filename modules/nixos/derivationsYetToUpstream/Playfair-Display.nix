{ 
	lib
,	fetchFromGitHub
,	stdenv
}:

stdenv.mkDerivation rec {
# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "Playfair-Display";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "2.100-RC3";

	src = fetchFromGitHub {
		owner = "clauseggers";
		repo = "Playfair";
		rev = "5ce16a618c8952b896311f75294e10e3db5fc009";
		hash = "sha256-9zc9qrhGWr6/vsyaO3mzEUwAnYhv2kxUP5AfaWyA/00=";
	};

	installPhase = ''
		mkdir -p $out/share/fonts/${pname}
		find ./fonts/VF-TTF/ -name \*.ttf -execdir mv {} $out/share/fonts/${pname} \;
	'';
		
	meta = with lib; {
		homepage = "https://github.com/clauseggers/Playfair";
		description = "Playfair is a general purpose Open Source typeface family.";
		license = with licenses; [ ofl ];
		maintainers = with maintainers; [ stereomato ];
		platforms = platforms.linux;
	};
}
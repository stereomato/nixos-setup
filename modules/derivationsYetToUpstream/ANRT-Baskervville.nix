{ 
	lib
,	fetchFromGitHub
,	stdenv
}:

stdenv.mkDerivation rec {
# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "ANRT-Baskervville";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "v1.003";

	src = fetchFromGitHub {
		owner = "anrt-type";
		repo = "ANRT-Baskervville";
		rev = "${version}";
		sparseCheckout = [ "fonts/otf/" ];
		hash = "sha256-pAKJlPmkDvyDdSEv8dOpPEvcesjwezOkOvde4eDRe34=";
	};

	installPhase = ''
		mkdir -p $out/share/fonts/${pname}
		find ./fonts/VF-TTF/ -name \*.otf -execdir mv {} $out/share/fonts/${pname} \;
	'';
		
	meta = with lib; {
		homepage = "https://github.com/anrt-type/ANRT-Baskervville";
		description = " Revival of Jacob's revival of Baskerville's typeface designed by ANRT students in 2017-2018.";
		license = with licenses; [ ofl ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
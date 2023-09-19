{ 
	lib
,	fetchzip
,	writeScript
,	stdenv
}:

stdenv.mkDerivation rec {
# Drop the -patched moniker as it seems to not need this anymore?
#	pname = "${actualName}-patched";
	pname = "Bitter-Pro";
	# Doesn't really matter, just gets incremented when I update the derivation
	version = "1";

	src = fetchzip {
		url = https://github.com/solmatas/BitterPro/files/4696176/otf.zip;
		sha256 = "1vgc80kdfbgj6j3b8ilyha82q5vp51b5izj4kwhw0jmlg6m0x7fk";
		stripRoot = false;
	};

	installPhase = ''
		mkdir -p $out/share/fonts/${pname}
		find . -name \*.otf -execdir mv {} $out/share/fonts/${pname} \;
	'';
		
	meta = with lib; {
		homepage = "https://github.com/solmatas/BitterPro";
		description = "Bitter Pro is is the extended version based on Bitter Project.";
		license = with licenses; [ ofl ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
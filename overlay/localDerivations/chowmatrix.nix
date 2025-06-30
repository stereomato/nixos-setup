{ 
	lib
, fetchFromGitHub
, stdenv
,	cmake
, pkg-config
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, freetype
, bzip2
, libpng
, brotli
, zlib
, alsa-lib
, curl
, webkitgtk_6_0
, gtk3
, pcre
, pcre2
, util-linux
, libselinux
, libsepol
, libthai
, libdatrie
, libXdmcp
, libdeflate
, jack2
, lv2
}:
stdenv.mkDerivation rec {
	pname = "ChowMatrix";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "Chowdhury-DSP";
		repo = pname;
		rev = "v${version}";
		sha256 = "14ksvc0ja43rwdgybvxk88404v6xh4645k9vf2qvwdg1jhsnp107";
		fetchSubmodules = true;
	};

	nativeBuildInputs = [
		pkg-config
		cmake
	];
	buildInputs = [
		libX11
		libXrandr
		libXinerama
		libXext
		libXcursor
		freetype
		bzip2
		libpng
		brotli
		zlib
		alsa-lib
		curl
		webkitgtk_6_0
		gtk3
		pcre
		pcre2
		util-linux
		libselinux
		libsepol
		libthai
		libdatrie
		libXdmcp
		libdeflate
		jack2
		lv2
	];

	cmakeFlags = [
		"-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
		"-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
	];

	installPhase = ''
		mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin
		cp -r ${pname}_artefacts/Release/LV2//${pname}.lv2 $out/lib/lv2
		cp -r ${pname}_artefacts/Release/VST3/${pname}.vst3 $out/lib/vst3
		cp ${pname}_artefacts/Release/Standalone/${pname} $out/bin
	'';
		
	meta = with lib; {
		homepage = "https://github.com/Chowdhury-DSP/ChowMatrix";
		description = "CHOW Matrix is a delay effect, made up of an infinitely growable tree of delay lines, each with individual controls for feedback, panning, distortion, and more.";
		license = with licenses; [ bsd3 ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}

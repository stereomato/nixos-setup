{ 
	lib
, fetchzip
,	autoPatchelfHook
, stdenv
, libX11
,	libxcb
,	libXaw
,	libXdmcp
}:

stdenv.mkDerivation rec {
	pname = "auburn-sounds-graillon-2";
	version = "2.7";

	src = fetchzip {
		url = "https://www.auburnsounds.com/downloads/Graillon-FREE-2.7.zip";
		sha256 = "0vi0nv1106cf6n5n5pbyaq77ar9fnlzf7bb7p475fprbfcia4mv4";
	};

	nativeBuildInputs = [
		autoPatchelfHook
	];


	buildInputs = [
		libX11
		libxcb
		libXaw
		libXdmcp
		# TODO: Understand this
		stdenv.cc.cc.lib
	];

	installPhase = ''
		mkdir -p $out/lib/lv2 $out/lib/vst3 $out/lib/vst
		cp -r Linux/Linux-64b-LV2-FREE/Auburn\ Sounds\ Graillon\ 2.lv2 $out/lib/lv2
		cp -r Linux/Linux-64b-VST2-FREE/ $out/lib/vst/
		cp -r Linux/Linux-64b-VST3-FREE/Auburn\ Sounds\ Graillon\ 2.vst3 $out/lib/vst3/
	'';
		
	meta = with lib; {
		homepage = "https://www.auburnsounds.com/products/Graillon.html";
		description = "Graillon is a Vocal Live Changer that brings a world of possibilities right into your DAW, with carefully designed features: Pitch-Tracking Modulation, Pitch Shifter and Pitch Correction.";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
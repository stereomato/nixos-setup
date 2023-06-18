{
  lib,
  stdenv,
  freetype,
  alsa-lib,
  autoPatchelfHook,
  fetchzip
}:
stdenv.mkDerivation rec {
  pname = "tal-reverb-4";
	version = "4.0.3";

	src = fetchzip {
		url = https://tal-software.com/downloads/plugins/TAL-Reverb-4_64_linux.zip;
		sha256 = "0gy9p4b8hs5n4n7hkmpgp6xr4xi0iinpi1fklra829qsa71z86a0";
	};

	nativeBuildInputs = [
		autoPatchelfHook
	];

	buildInputs = [
    freetype
    alsa-lib
		# TODO: Understand this
		stdenv.cc.cc.lib
	];

  installPhase = ''
    mkdir -p $out/lib/vst3
		cp -r TAL-Reverb-4.vst3/ $out/lib/vst3
  '';

  meta = with lib; {
		homepage = "https://tal-software.com/products/tal-reverb-4";
		description = " TAL-Reverb-4 is a high quality plate reverb with a vintage 80's character. ";
		license = with licenses; [ unfree ];
		maintainers = with maintainers; [ pearsche ];
		platforms = platforms.linux;
	};
}
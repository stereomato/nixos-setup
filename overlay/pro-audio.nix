let proaudioOverlay = (final: prev: {
	chowmatrix = prev.callPackage ./localDerivations/chowmatrix.nix {};
	auburn-sounds-graillon-2 = prev.callPackage ./localDerivations/auburn-sounds-graillon-2.nix {};
	tal-reverb-4 = prev.callPackage ./localDerivations/tal-reverb-4.nix {};
});
in proaudioOverlay
{
  stdenvNoCC,
  commit-mono-stereomato-script,
  commit-mono
}: stdenvNoCC.mkDerivation rec {
  pname = "${commit-mono.pname}-stereomato";
  version = "${commit-mono.version}";

  # Copy the source from commit-mono
  src = commit-mono.src;

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;
  dontFixup = true;
  doCheck = false;

  installPhase = commit-mono.installPhase + ''
    ${commit-mono-stereomato-script}/bin/cmsc --srcPath=${commit-mono}/share/fonts/opentype --localPath=$out/share/fonts/opentype --fontFormat=otf
    ${commit-mono-stereomato-script}/bin/cmsc --srcPath=${commit-mono}/share/fonts/truetype --localPath=$out/share/fonts/truetype --fontFormat=ttf
  '';
}
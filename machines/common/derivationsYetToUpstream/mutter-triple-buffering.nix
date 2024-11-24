{
  mutter,
  mutter-triple-buffering-src,
  gvdb-src
}:
mutter.overrideAttrs (old: {
  src = mutter-triple-buffering-src;
  preConfigure = ''
    cp -a "${gvdb-src}" ./subprojects/gvdb
  '';
})

{ ... }:
{
	environment.variables = {
			# MacOS-like font rendering
			# Font emboldering
			# and
			# fuzziness a la macOS/W95
			FREETYPE_PROPERTIES = "truetype:interpreter-version=35 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0 autofitter:no-stem-darkening=0";
			EDITOR = "nano";
		};
}
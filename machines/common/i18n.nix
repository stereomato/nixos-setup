{ pkgs, ... }:
{
	i18n = {
		defaultLocale = "es_PE.UTF-8";
		extraLocaleSettings = {
			LANG="en_US.UTF-8";
		};
		supportedLocales = [ "all" ];
		# KDE issue with uh... QT_IM_MODULE and GTK_IM_MODULE
		#inputMethod = {
		#	enabled = "ibus";
		#	ibus = {
		#		engines = with pkgs.ibus-engines; [
		#			typing-booster
		#			# https://github.com/NixOS/nixpkgs/pull/282148
		#			# mozc
		#			uniemoji
		#		];
		#	};
		#};
	};
}


{ pkgs, ... }:
{
	i18n = {
		defaultLocale = "es_PE.UTF-8";
		extraLocaleSettings = {
			LANG="en_US.UTF-8";
		};
		supportedLocales = [ "all" ];
		inputMethod = {
			enabled = "ibus";
			ibus = {
				engines = with pkgs.ibus-engines; [ 
					typing-booster
					mozc
					uniemoji
				];
			};
		};
	};
}
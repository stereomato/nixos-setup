{ ... }:
{

	services = {
		# nice daemon, important for desktop responsiveness
		# Antivirus
		clamav = {
			# Disabled as it's quite annoying to use 1GB of ram always on a system with less than 32GB of ram (my current laptop lmao)
			# Both sets have their settings values.
			daemon = {
				enable = false;
				settings = {
				};
			};
			updater = {
				enable = false;
				# By default the updater runs @ every hour, and does 12 database checks per day.
			};
		};
	};
}

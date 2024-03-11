{ ...}:
{
networking = {
		nat = {
			enable = true;
		};
		firewall = {
			enable = true;
			allowedUDPPorts = [
				# Syncthing
				22000
				21027
			];
			allowedTCPPorts = [
				# Syncthing
				22000
				# Fragments
				59432
			];
		};
	};
}
{ ... }:{
	# Limits needed for pro audio
	security.pam = {
		loginLimits = [
			{
				domain = "@audio";
				type = "-";
				item = "rtprio";
				value = 98;
			}
			{
				domain = "@audio";
				type = "-";
				item = "memlock";
				value = "unlimited";
			}
			{
				domain = "@audio";
				type = "-";
				item = "nice";
				value = -11;
			}
		];
	};
}
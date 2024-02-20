{ ... }: {
	documentation = {
		man = {
			generateCaches = true;
			mandoc = {
				enable = true;
			};
			man-db = {
				enable = false;
			};
		};
		dev = {
			enable = true;
		};
	};
}
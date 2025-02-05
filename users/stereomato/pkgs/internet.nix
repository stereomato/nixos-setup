{config, lib, pkgs, ... }:{
nixpkgs = {
		overlays = [(
			self: super: {
				google-chrome = super.google-chrome.override {
					# commandLineArgs = "--enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true --use-vulkan=true";
					commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,ParallelDownloading,UseMultiPlaneFormatForHardwareVideo --disable-font-subpixel-positioning=true --enable-zero-copy=true";
				};
			}
		)];
};
	users.users.stereomato.packages = with pkgs; [
		# Web Browsers
		google-chrome

		# Chat/Voice Chat apps
		tdesktop discord mumble element-desktop

		# Password management
		bitwarden 

		# Downloaders
		curl wget aria megacmd

		# VPN
		protonvpn-gui

		# Virtual classes
		zoom-us
	] ++ lib.optionals config.services.desktopManager.plasma6.enable [
			# Chat Apps
			kdePackages.neochat nheko kaidan
			
			# Downloaders
			kdePackages.kget

			# Web browser
			kdePackages.falkon # kdePackages.angelfish
	]
		++ lib.optionals config.services.xserver.desktopManager.gnome.enable  [
				# Chat apps
				fractal
				
				# Downloaders
				fragments
			];

}

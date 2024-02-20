{ ... }:{
  gtk = {
    enable = true;
    gtk4 = {
      extraConfig = {
        # Blurry font fix for low dpi screens.
        # Outdated by the time that GTK 4.12 lands on nixpkgs.
        gtk-hint-font-metrics = 1;
      };
    };
  };
}
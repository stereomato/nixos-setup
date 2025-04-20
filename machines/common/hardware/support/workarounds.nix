{ ... }: {
  services.udisks2.settings = {
    "mount_options.conf" = {
      defaults = {
        ntfs_drivers = "ntfs ntfs3";
      };
    };
  };
}
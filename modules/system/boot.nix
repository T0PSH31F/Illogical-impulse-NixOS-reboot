{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 3;
    };

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Kernel parameters
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    # Kernel modules
    kernelModules = [ "kvm-intel" "kvm-amd" ];
    extraModulePackages = [ ];

    # Initial ramdisk
    initrd = {
      availableKernelModules = [ 
        "xhci_pci" 
        "ahci" 
        "nvme" 
        "usb_storage" 
        "sd_mod" 
        "rtsx_pci_sdmmc" 
      ];
      kernelModules = [ ];
    };

    # Plymouth boot splash
    plymouth = {
      enable = true;
      theme = "breeze";
    };

    # Temporary file systems
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };

    # Support for additional file systems
    supportedFilesystems = [ "ntfs" "exfat" ];
  };
}
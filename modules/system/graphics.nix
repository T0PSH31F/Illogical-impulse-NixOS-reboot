{ config, lib, pkgs, ... }:

{
  # Graphics drivers
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    
    extraPackages = with pkgs; [
      intel-media-driver # VAAPI driver for Intel
      vaapiIntel         # VAAPI driver for Intel
      vaapiVdpau         # VAAPI driver for VDPAU
      libvdpau-va-gl     # VDPAU driver for VA-API
      intel-compute-runtime
    ];
  };

  # Enable hardware acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Force Intel iHD driver
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
    glxinfo
    vainfo
    libva-utils
  ];
}

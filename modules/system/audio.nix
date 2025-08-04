{ config, lib, pkgs, ... }:

{
  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    
    # Low latency configuration
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 32;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 32;
      };
    };
  };
  
  # Additional audio packages
  environment.systemPackages = with pkgs; [
    # Audio control
    pavucontrol
    pulsemixer
    
    # Audio players
    mpv
    vlc
    
    # Audio editing
    audacity
    
    # Codecs
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    alsa-utils
    playerctl
    wireplumber # Pipewire patchbay
    helvum # Pipewire patchbay
  ];

  # Hardware audio support
  hardware.pulseaudio.enable = false;
}
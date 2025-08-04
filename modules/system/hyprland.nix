{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.dotfiles.features.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    # Enable Hyprland
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };

    # Required packages for Hyprland
    environment.systemPackages = with pkgs; [
      # Core Wayland packages
      wayland
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlroots

      # Hyprland ecosystem
      hyprpicker
      hyprpaper
      hypridle
      hyprlock
      hyprshot

      # Essential tools
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      qt5.qtwayland
      qt6.qtwayland
      
      # Notification daemon
      dunst
      libnotify

      # Application launcher
      rofi-wayland
      
      # File manager
      nautilus
      
      # Terminal
      kitty
      
      # Screenshot tools
      grim
      slurp
      
      # Screen recording
      wf-recorder
      
      # Color picker
      hyprpicker
      
      # Clipboard manager
      cliphist
      
      # Network manager applet
      networkmanagerapplet
      
      # Bluetooth manager
      blueman
      
      # Volume control
      pavucontrol
      
      # System monitor
      btop
      
      # Image viewer
      imv
      
      # Video player
      mpv
      
      # PDF viewer
      zathura
      
      # Archive manager
      file-roller
    ];

    # XDG portal configuration
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    # Security
    security.pam.services.hyprlock = {};
    
    # Session variables
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
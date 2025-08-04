{ config, lib, pkgs, ... }:

{
  # Desktop environment configuration
  services.xserver = {
    enable = true;
    
    # Display manager
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    
    # Keyboard layout
    xkb = {
      layout = "us";
      variant = "";
      options = "caps:escape";
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Noto Sans" "Liberation Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Liberation Mono" ];
      };
    };
  };

  # Polkit
  security.polkit.enable = true;

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # Thunar file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  # Tumbler for thumbnails
  services.tumbler.enable = true;

  # GVFS for virtual file systems
  services.gvfs.enable = true;

  # UDisks for removable media
  services.udisks2.enable = true;

  # Location services
  services.geoclue2.enable = true;

  # Desktop packages
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    wl-clipboard
    wlr-randr
    wayland-utils
    
    # Screenshot tools
    grim
    slurp
    
    # Notification daemon
    dunst
    
    # Application launcher
    rofi-wayland
    
    # File managers
    nautilus
    
    # Archive managers
    file-roller
    
    # Image viewers
    imv
    
    # PDF viewers
    zathura
    
    # System monitors
    htop
    btop
    
    # Network
    networkmanagerapplet
  ];
}
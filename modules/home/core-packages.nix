{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.core-packages;
in
{
  options.dotfiles.home.core-packages = {
    enable = lib.mkEnableOption "Core packages from original dotfiles";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Direct mappings from previous_dependencies.conf
      axel bc coreutils cliphist cmake curl fuzzel rsync wget ripgrep
      gojq nodejs npm meson typescript gjs xdg-user-dirs tinyxml2
      
      # GTK/UI packages
      gtkmm3 gtksourceviewmm cairomm gtk-layer-shell gtk3 gtksourceview3
      gobject-introspection
      
      # Python packages
      python3 python311Packages.pillow python311Packages.pywal
      python311Packages.setuptools-scm python311Packages.wheel
      python311Packages.build python311Packages.pywayland python311Packages.psutil
      
      # Desktop portals
      xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
      
      # Audio/Media
      pavucontrol wireplumber libdbusmenu-gtk3 playerctl
      
      # Wayland tools
      swww webp-pixbuf-loader wl-clipboard hyprpicker wlogout
      
      # System utilities
      upower yad ydotool xdg-user-dirs-gtk polkit_gnome
      gnome.gnome-keyring gnome.gnome-control-center blueberry
      gammastep gnome.gnome-bluetooth brightnessctl ddcutil
      
      # Hyprland ecosystem
      hypridle hyprlock
      
      # Qt
      qt5ct qt5.qtwayland
      
      # Fonts
      fontconfig jetbrains-mono
      
      # Shell/Terminal
      fish foot starship
      
      # Screenshot/Recording
      swappy wf-recorder grim tesseract slurp
    ];
  };
}
{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.packages;
in
{
  options.dotfiles.home.packages = {
    enable = lib.mkEnableOption "Core packages from original dotfiles";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # From previous_dependencies.conf - core utilities
      axel
      bc
      coreutils
      cliphist
      cmake
      curl
      fuzzel
      rsync
      wget
      ripgrep
      gojq
      nodejs
      npm
      meson
      typescript
      gjs
      xdg-user-dirs
      tinyxml2
      
      # Python packages
      python3
      python311Packages.pillow
      python311Packages.pywal
      python311Packages.setuptools-scm
      python311Packages.wheel
      python311Packages.build
      python311Packages.pywayland
      python311Packages.psutil
      
      # Desktop portals
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      
      # Audio
      pavucontrol
      wireplumber
      libdbusmenu-gtk3
      playerctl
      
      # Wayland/Hyprland tools
      swww
      webp-pixbuf-loader
      wl-clipboard
      hyprpicker
      wlogout
      
      # GTK/UI
      gtk-layer-shell
      gtk3
      gtksourceview3
      gobject-introspection
      gtkmm3
      gtksourceviewmm
      cairomm
      
      # System utilities
      upower
      yad
      ydotool
      xdg-user-dirs-gtk
      polkit_gnome
      gnome.gnome-keyring
      gnome.gnome-control-center
      blueberry
      gammastep
      gnome.gnome-bluetooth
      brightnessctl
      ddcutil
      
      # Hyprland extras
      hypridle
      hyprlock
      
      # Qt
      qt5ct
      qt5.qtwayland
      
      # Fonts (from the conf)
      fontconfig
      # Note: ttf-readex-pro, ttf-jetbrains-mono-nerd, etc. need to be mapped to nixpkgs equivalents
      jetbrains-mono
      
      # Shell
      fish
      foot
      starship
      
      # Screenshot/recording
      swappy
      wf-recorder
      grim
      tesseract
      slurp
    ];
  };
}
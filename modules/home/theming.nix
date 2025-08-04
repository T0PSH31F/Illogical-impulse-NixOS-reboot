{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.dotfiles.home.theming;
in
{
  options.dotfiles.home.theming = {
    enable = lib.mkEnableOption "Theming configuration";
  };

  config = lib.mkIf cfg.enable {
    # GTK theming
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "blue" ];
          size = "standard";
          tweaks = [ "rimless" "black" ];
          variant = "mocha";
        };
      };
      
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "blue";
        };
      };
      
      cursorTheme = {
        name = "Catppuccin-Mocha-Blue-Cursors";
        package = pkgs.catppuccin-cursors.mochaBlue;
        size = 24;
      };
      
      font = {
        name = "Inter";
        size = 11;
      };
      
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = false;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH_HORIZ";
        gtk-menu-images = true;
        gtk-button-images = true;
      };
      
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-decoration-layout = "appmenu:none";
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = false;
      };
    };

    # Qt theming
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "gtk2";
        package = pkgs.qt5.qtbase;
      };
    };

    # Install theme packages
    home.packages = with pkgs; [
      # Themes
      catppuccin-gtk
      catppuccin-kvantum
      catppuccin-cursors
      
      # Icon themes
      papirus-icon-theme
      tela-icon-theme
      
      # Cursor themes
      bibata-cursors
      
      # Fonts
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      font-awesome
      material-design-icons
      
      # Theming tools
      qt5ct
      qt6ct
      libsForQt5.qtstyleplugin-kvantum
      libsForQt6.qtstyleplugin-kvantum
      
      # Nerd Fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Iosevka" ]; })
      
      # System fonts
      roboto
      noto-fonts-cjk
      
      # Additional fonts
      source-code-pro
      ubuntu_font_family
      liberation_ttf
    ];

    # Home cursor theme
    home.pointerCursor = {
      name = "Catppuccin-Mocha-Blue-Cursors";
      package = pkgs.catppuccin-cursors.mochaBlue;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    # Wallpaper and theme files
    home.file = {
      ".config/wallpapers".source = ../../Extras/wallpapers;
      ".local/share/themes".source = ../../Extras/themes;
      ".local/share/icons".source = ../../Extras/icons;
    };

    # XDG settings
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        videos = "${config.home.homeDirectory}/Videos";
        templates = "${config.home.homeDirectory}/Templates";
        publicShare = "${config.home.homeDirectory}/Public";
      };
      
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
          "application/pdf" = "zathura.desktop";
          "image/jpeg" = "imv.desktop";
          "image/png" = "imv.desktop";
          "image/gif" = "imv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "audio/mpeg" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "text/plain" = "nvim.desktop";
          "application/json" = "nvim.desktop";
        };
      };
      
      # Matugen configuration
      programs.matugen = {
        enable = true;
        package = inputs.matugen.packages.${pkgs.system}.default;
      };

      # Kvantum configuration
      configFile."Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Mocha-Blue
      '';

      # Qt5ct configuration
      configFile."qt5ct/qt5ct.conf".text = ''
        [Appearance]
        color_scheme_path=${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.colors
        custom_palette=false
        icon_theme=Papirus-Dark
        standard_dialogs=default
        style=kvantum

        [Fonts]
        fixed=@Variant(\0\0\0@\0\0\0\x16\0J\0\x65\0t\0\x42\0r\0\x61\0i\0n\0s\0 \0M\0o\0n\0o@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
        general=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@"\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=0
        cursor_flash_time=1000
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=@Invalid()
        keyboard_scheme=2
        menus_have_icons=true
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3
      '';

      # Qt6ct configuration
      configFile."qt6ct/qt6ct.conf".text = ''
        [Appearance]
        color_scheme_path=${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.colors
        custom_palette=false
        icon_theme=Papirus-Dark
        standard_dialogs=default
        style=kvantum

        [Fonts]
        fixed=@Variant(\0\0\0@\0\0\0\x16\0J\0\x65\0t\0\x42\0r\0\x61\0i\0n\0s\0 \0M\0o\0n\0o@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
        general=@Variant(\0\0\0@\0\0\0\n\0I\0n\0t\0\x65\0r@"\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=0
        cursor_flash_time=1000
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=@Invalid()
        keyboard_scheme=2
        menus_have_icons=true
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3
      '';

      # Fontconfig
      configFile."fontconfig/fonts.conf".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <alias>
            <family>sans-serif</family>
            <prefer>
              <family>Inter</family>
              <family>Noto Sans</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          
          <alias>
            <family>serif</family>
            <prefer>
              <family>Noto Serif</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          
          <alias>
            <family>monospace</family>
            <prefer>
              <family>JetBrains Mono</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
        </fontconfig>
      '';
    };

    # Environment variables for theming
    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };
  };
}
{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.multimedia;
in
{
  options.dotfiles.home.multimedia = {
    enable = lib.mkEnableOption "Multimedia applications";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Video players
      mpv
      vlc
      
      # Audio
      pavucontrol
      pulsemixer
      spotify
      
      # Image viewers and editors
      feh
      imv
      gimp
      inkscape
      
      # Video editing
      kdenlive
      obs-studio
      
      # Audio editing
      audacity
      
      # Media tools
      ffmpeg
      imagemagick
      
      # Screen capture
      grim
      slurp
      wl-clipboard
      
      # Document viewers
      zathura
      evince
    ];

    programs.mpv = {
      enable = true;
      config = {
        # Video
        vo = "gpu";
        hwdec = "vaapi";
        profile = "gpu-hq";
        
        # Audio
        audio-device = "auto";
        volume = 70;
        volume-max = 100;
        
        # Subtitles
        sub-auto = "fuzzy";
        sub-file-paths = "subs";
        
        # Interface
        osd-level = 1;
        osd-duration = 2000;
        
        # Performance
        cache = true;
        demuxer-max-bytes = "150MiB";
        demuxer-max-back-bytes = "75MiB";
      };
      
      bindings = {
        "WHEEL_UP" = "seek 10";
        "WHEEL_DOWN" = "seek -10";
        "WHEEL_LEFT" = "add volume -2";
        "WHEEL_RIGHT" = "add volume 2";
      };
    };

    services.playerctld.enable = true;

    # Zathura PDF viewer
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
        adjust-open = "best-fit";
        pages-per-row = "1";
        scroll-page-aware = "true";
        scroll-full-overlap = "0.01";
        scroll-step = "100";
        zoom-min = "10";
        guioptions = "none";
        
        # Colors (Material theme)
        default-bg = "#1e1e2e";
        default-fg = "#cdd6f4";
        statusbar-bg = "#313244";
        statusbar-fg = "#cdd6f4";
        inputbar-bg = "#1e1e2e";
        inputbar-fg = "#cdd6f4";
        notification-bg = "#1e1e2e";
        notification-fg = "#cdd6f4";
        notification-error-bg = "#f38ba8";
        notification-error-fg = "#1e1e2e";
        notification-warning-bg = "#f9e2af";
        notification-warning-fg = "#1e1e2e";
        highlight-color = "#f9e2af";
        highlight-active-color = "#89b4fa";
        completion-bg = "#313244";
        completion-fg = "#cdd6f4";
        completion-highlight-bg = "#575268";
        completion-highlight-fg = "#cdd6f4";
        recolor-lightcolor = "#1e1e2e";
        recolor-darkcolor = "#cdd6f4";
      };
      
      mappings = {
        u = "scroll half-up";
        d = "scroll half-down";
        D = "toggle_page_mode";
        r = "reload";
        R = "rotate";
        K = "zoom in";
        J = "zoom out";
        i = "recolor";
        p = "print";
      };
    };
  };
}
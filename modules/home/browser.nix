{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.browser;
in
{
  options.dotfiles.home.browser = {
    enable = lib.mkEnableOption "Browser configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
        
        settings = {
          # Privacy settings
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state" = false;
          
          # Performance
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-vpx.enabled" = true;
          
          # UI customization
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "browser.uidensity" = 0;
          
          # New tab page
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          privacy-badger
          decentraleyes
          clearurls
          firefox-color
        ];

        userChrome = ''
          /* Hide tab bar when only one tab */
          #tabbrowser-tabs {
            visibility: collapse !important;
          }
          
          #tabbrowser-tabs[overflow="true"] {
            visibility: visible !important;
          }
          
          /* Compact navigation bar */
          #nav-bar {
            padding-top: 0px !important;
            padding-bottom: 0px !important;
          }
          
          /* Hide unnecessary buttons */
          #tracking-protection-icon-container,
          #identity-box {
            display: none !important;
          }
        '';
      };
    };

    programs.chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
      
      commandLineArgs = [
        "--enable-features=VaapiVideoDecoder"
        "--use-gl=egl"
        "--enable-zero-copy"
      ];
    };

    home.packages = with pkgs; [
      # Additional browsers
      brave
      tor-browser-bundle-bin
    ];
  };
}
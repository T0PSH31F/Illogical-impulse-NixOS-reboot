{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./users.nix
    ./desktop.nix
    ./graphics.nix
    ./audio.nix
    ./security.nix
    ./services.nix
    ./virtualization.nix
    ./hyprland.nix
    ./audio.nix
    ./bluetooth.nix
    ./fonts.nix
  ];

  # System-wide configuration
  system.stateVersion = "24.05";
  
  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "@wheel" ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };

  # Time zone and locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Console configuration
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  options.dotfiles = {
    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "user";
        description = "Username";
      };
      description = lib.mkOption {
        type = lib.types.str;
        default = "Main user";
        description = "User description";
      };
      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zsh;
        description = "User shell";
      };
    };

    features = {
      hyprland.enable = lib.mkEnableOption "Hyprland window manager";
      quickshell.enable = lib.mkEnableOption "Quickshell widget system";
      ags.enable = lib.mkEnableOption "AGS widget system (deprecated)";
      ai.enable = lib.mkEnableOption "AI features";
      gaming.enable = lib.mkEnableOption "Gaming support";
      development.enable = lib.mkEnableOption "Development tools";
      multimedia.enable = lib.mkEnableOption "Multimedia support";
      theming.enable = lib.mkEnableOption "Theming support";
    };

    theme = {
      wallpaper = lib.mkOption {
        type = lib.types.str;
        default = "~/Pictures/wallpapers/default.jpg";
        description = "Default wallpaper path";
      };
      colorScheme = lib.mkOption {
        type = lib.types.str;
        default = "material";
        description = "Color scheme";
      };
      darkMode = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable dark mode";
      };
      accentColor = lib.mkOption {
        type = lib.types.str;
        default = "blue";
        description = "Accent color";
      };
    };

    ai = {
      gemini.enable = lib.mkEnableOption "Google Gemini API";
      ollama.enable = lib.mkEnableOption "Ollama local models";
      openai.enable = lib.mkEnableOption "OpenAI API";
    };

    display = {
      monitors = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Monitor name";
            };
            width = lib.mkOption {
              type = lib.types.int;
              description = "Monitor width";
            };
            height = lib.mkOption {
              type = lib.types.int;
              description = "Monitor height";
            };
            refreshRate = lib.mkOption {
              type = lib.types.int;
              default = 60;
              description = "Monitor refresh rate";
            };
            position = lib.mkOption {
              type = lib.types.str;
              default = "0x0";
              description = "Monitor position";
            };
            primary = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Primary monitor";
            };
          };
        });
        default = [];
        description = "Monitor configuration";
      };
    };
  };
}
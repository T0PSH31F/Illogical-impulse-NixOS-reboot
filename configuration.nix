{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/system
  ];

  # User configuration - modify these values
  dotfiles = {
    user = {
      name = "user";
      description = "Main user";
      shell = pkgs.zsh;
    };

    # Feature toggles
    features = {
      hyprland.enable = true;
      quickshell.enable = true;
      ags.enable = false; # Deprecated but available
      ai.enable = true;
      gaming.enable = true;
      development.enable = true;
      multimedia.enable = true;
      theming.enable = true;
    };

    # Theme configuration
    theme = {
      wallpaper = "~/Pictures/wallpapers/default.jpg";
      colorScheme = "material"; # material, catppuccin, etc.
      darkMode = true;
      accentColor = "blue";
    };

    # AI configuration
    ai = {
      gemini.enable = true;
      ollama.enable = true;
      openai.enable = false;
    };

    # Display configuration
    display = {
      monitors = [
        {
          name = "DP-1";
          width = 1920;
          height = 1080;
          refreshRate = 144;
          position = "0x0";
          primary = true;
        }
      ];
    };
  };

  # System configuration
  system.stateVersion = "24.05";
  
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-hyprland";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User account
  users.users.${config.dotfiles.user.name} = {
    isNormalUser = true;
    description = config.dotfiles.user.description;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" ];
    shell = config.dotfiles.user.shell;
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts
  ];
}
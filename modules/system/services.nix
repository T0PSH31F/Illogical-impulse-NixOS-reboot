{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles;
in
{
  # Enable essential services
  services = {
    # Display manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Bluetooth
    blueman.enable = true;
    
    # Location services
    geoclue2.enable = true;
    
    # Printing
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip epson-escpr ];
    };
    
    # USB automounting
    udisks2.enable = true;
    
    # Thumbnail generation
    tumbler.enable = true;
    
    # GNOME keyring
    gnome.gnome-keyring.enable = true;
    
    # Power management
    power-profiles-daemon.enable = true;
    
    # Firmware updates
    fwupd.enable = true;
    
    # D-Bus
    dbus.enable = true;
    
    # UPower for battery management
    upower.enable = true;
    
    # Scanning
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    
    # Locate database
    locate = {
      enable = true;
      package = pkgs.mlocate;
      localuser = null;
    };
    
    # Automatic garbage collection
    nix-gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    
    # Logrotate
    logrotate = {
      enable = true;
      settings = {
        header = {
          dateext = true;
          compress = true;
          rotate = 4;
          weekly = true;
          missingok = true;
          notifempty = true;
        };
      };
    };
    
    # Flatpak
    flatpak.enable = true;
    
    # Fstrim for SSD
    fstrim = {
      enable = true;
      interval = "weekly";
    };
    
    # Ollama (if AI is enabled)
    ollama = lib.mkIf cfg.ai.ollama.enable {
      enable = true;
      acceleration = "cuda"; # or "rocm" for AMD
    };
    
    # Automatic updates
    system-config-printer.enable = true;
  };

  # Systemd services
  systemd = {
    services = {
      # Ensure NetworkManager-wait-online doesn't block boot
      NetworkManager-wait-online.enable = false;
    };
    
    # User services
    user.services = {
      # Cleanup temporary files
      cleanup-downloads = {
        description = "Cleanup Downloads folder";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.findutils}/bin/find /home/user/Downloads -type f -mtime +30 -delete";
        };
      };
      
      # Polkit authentication agent
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
    
    # User timers
    user.timers = {
      cleanup-downloads = {
        description = "Cleanup Downloads folder weekly";
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
        wantedBy = [ "timers.target" ];
      };
    };
    
    # System sleep settings
    sleep.extraConfig = ''
      HibernateDelaySec=1h
    '';
  };

  # Enable polkit
  security.polkit.enable = true;
  
  # Environment packages
  environment.systemPackages = with pkgs; [
    # System monitoring
    systemd-analyze
    
    # Service management
    systemctl-tui
    
    # Log viewing
    lnav
    
    # Process management
    psmisc
    
    # Hardware info
    lshw
    hwinfo
    
    # Disk utilities
    smartmontools
    hdparm
    
    # Network utilities
    iftop
    nethogs
    
    # System utilities
    tree
    file
    which
    lsof
  ];
}
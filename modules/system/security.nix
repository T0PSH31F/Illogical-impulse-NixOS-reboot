{ config, lib, pkgs, ... }:

{
  # Security configuration
  security = {
    # Enable polkit
    polkit.enable = true;

    # Enable rtkit for audio
    rtkit.enable = true;

    # PAM configuration
    pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock = {};
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };

    # Sudo configuration
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };

    # AppArmor
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
    };

    # Audit
    audit = {
      enable = true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    # Kernel hardening
    protectKernelImage = true;
  };

  # Additional security packages
  environment.systemPackages = with pkgs; [
    polkit_gnome
    gnome.gnome-keyring
    seahorse # GUI for gnome-keyring

    # Password managers
    keepassxc

    # Encryption
    gnupg
    pinentry-gtk2

    # Network security
    nmap
    wireshark

    # System security
    rkhunter
    chkrootkit

    # Firewall management
    gufw
  ];

  # Enable AppArmor
  security.apparmor.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  # Fail2ban
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
  };

  # ClamAV antivirus
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  # GPG agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };

  # Polkit GNOME agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
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

  # GNOME Keyring
  services.gnome.gnome-keyring.enable = true;
}

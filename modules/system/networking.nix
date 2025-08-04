{ config, lib, pkgs, ... }:

{
  # Networking configuration
  networking = {
    hostName = "nixos-hyprland";
    
    # Network manager
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      dns = "systemd-resolved";
    };

    # Wireless
    wireless.enable = false; # Use NetworkManager instead

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      allowPing = true;
    };

    # DNS
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    
    # Hosts file
    extraHosts = ''
      127.0.0.1 localhost
    '';
  };

  # Resolved DNS service
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  # Enable network discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
    openFirewall = true;
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # Network tools
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    wireguard-tools
    iw
    ethtool
    tcpdump
    nmap
    iperf3
    wget
    curl
    rsync
  ];
}
{ config, lib, pkgs, ... }:

{
  # User configuration
  users = {
    defaultUserShell = pkgs.zsh;
    
    users.user = {
      isNormalUser = true;
      description = "Main User";
      extraGroups = [ 
        "wheel" 
        "networkmanager" 
        "audio" 
        "video" 
        "input" 
        "storage" 
        "optical" 
        "lp" 
        "scanner" 
        "docker" 
        "libvirtd"
        "kvm"
      ];
      
      openssh.authorizedKeys.keys = [
        # Add your SSH public keys here
        # "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
      ];
      
      packages = with pkgs; [
        # User-specific packages can go here
      ];
    };
  };

  # Sudo configuration
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        users = [ "user" ];
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Dconf for GTK applications
  programs.dconf.enable = true;
}
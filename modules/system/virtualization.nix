{ config, lib, pkgs, ... }:

{
  # Virtualization configuration
  virtualisation = {
    # Docker
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    
    # Podman (alternative to Docker)
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    
    # libvirt/QEMU
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    
    # Spice USB redirection
    spiceUSBRedirection.enable = true;
  };

  # Virtualization packages
  environment.systemPackages = with pkgs; [
    # Docker tools
    docker-compose
    docker-buildx
    
    # Podman tools
    podman-compose
    podman-tui
    
    # VM management
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    
    # Container tools
    distrobox
    
    # QEMU tools
    qemu
    quickemu
    
    # Other virtualization
    virtualbox
  ];
}{ config, lib, pkgs, ... }:

{
  # Virtualization configuration
  virtualisation = {
    # Docker
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
    
    # Podman (alternative to Docker)
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    
    # libvirt/QEMU
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    
    # Spice USB redirection
    spiceUSBRedirection.enable = true;
  };

  # Virtualization packages
  environment.systemPackages = with pkgs; [
    # Docker tools
    docker-compose
    docker-buildx
    
    # Podman tools
    podman-compose
    podman-tui
    
    # VM management
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    
    # Container tools
    distrobox
    
    # QEMU tools
    qemu
    quickemu
    
    # Other virtualization
    virtualbox
  ];
}
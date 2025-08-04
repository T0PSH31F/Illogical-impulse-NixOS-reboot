{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./core-packages.nix
    ./hyprland.nix
    ./applications.nix
    ./theming.nix
    ./scripts.nix
    ./quickshell.nix
    ./ags.nix
    ./terminal.nix
    ./shell.nix
    ./editor.nix
    ./browser.nix
    ./multimedia.nix
    ./development.nix
    ./ai.nix
  ];

  # Common home-manager configuration
  home.stateVersion = "24.05";
  
  # Enable XDG
  xdg.enable = true;
  
  # Common packages
  home.packages = with pkgs; [
    # System utilities
    file
    which
    tree
    
    # Archive utilities
    unzip
    zip
    
    # Network utilities
    wget
    curl
  ];

  options.dotfiles.home = {
    hyprland.enable = lib.mkEnableOption "Hyprland configuration";
    quickshell.enable = lib.mkEnableOption "Quickshell widget system";
    ags.enable = lib.mkEnableOption "AGS widget system";
    terminal.enable = lib.mkEnableOption "Terminal configuration";
    shell.enable = lib.mkEnableOption "Shell configuration";
    editor.enable = lib.mkEnableOption "Editor configuration";
    browser.enable = lib.mkEnableOption "Browser configuration";
    multimedia.enable = lib.mkEnableOption "Multimedia applications";
    development.enable = lib.mkEnableOption "Development tools";
    theming.enable = lib.mkEnableOption "Theming and appearance";
    ai.enable = lib.mkEnableOption "AI tools and configuration";
  };
}
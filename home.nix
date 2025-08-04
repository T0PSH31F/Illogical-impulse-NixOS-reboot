{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/home
  ];

  home.username = "t0psh31f";
  home.homeDirectory = "/home/t0psh31f";
  home.stateVersion = "24.05";

  # Enable all dotfile modules
  dotfiles = {
    home = {
      core-packages.enable = true;
      hyprland.enable = true;
      quickshell.enable = true;
      applications.enable = true;
      theming.enable = true;
      scripts.enable = true;
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
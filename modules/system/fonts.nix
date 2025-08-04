{ config, lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      material-design-icons
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Iosevka" ]; })
      roboto
      ubuntu_font_family
      liberation_ttf
      source-code-pro
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Inter" "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "JetBrains Mono" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
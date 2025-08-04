{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.fuzzel;
in
{
  options.dotfiles.home.fuzzel = {
    enable = lib.mkEnableOption "Fuzzel application launcher";
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.kitty}/bin/kitty";
          layer = "overlay";
          font = "JetBrains Mono:size=12";
          dpi-aware = "auto";
          icon-theme = "Papirus-Dark";
          fields = "filename,name,generic";
          password-character = "*";
          filter-desktop = true;
          no-exit-on-keyboard-focus-loss = false;
        };

        colors = {
          background = "1e1e2eff";
          text = "cdd6f4ff";
          match = "f38ba8ff";
          selection = "585b70ff";
          selection-text = "cdd6f4ff";
          selection-match = "f38ba8ff";
          border = "b4befeff";
        };

        border = {
          width = 2;
          radius = 8;
        };

        dmenu = {
          exit-immediately-if-empty = true;
        };
      };
    };
  };
}
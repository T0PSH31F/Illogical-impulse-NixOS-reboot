{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.dotfiles.home.quickshell;
in
{
  options.dotfiles.home.quickshell = {
    enable = lib.mkEnableOption "QuickShell configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.quickshell.packages.${pkgs.system}.default
    ];

    # QuickShell configuration files
    xdg.configFile = {
      "quickshell/shell.qml".source = ../../.config/quickshell/shell.qml;
      "quickshell/Bar.qml".source = ../../.config/quickshell/Bar.qml;
      "quickshell/components".source = ../../.config/quickshell/components;
      "quickshell/modules".source = ../../.config/quickshell/modules;
    };

    # Systemd service for QuickShell
    systemd.user.services.quickshell = {
      Unit = {
        Description = "QuickShell Wayland compositor shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      
      Service = {
        Type = "simple";
        ExecStart = "${inputs.quickshell.packages.${pkgs.system}.default}/bin/quickshell";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
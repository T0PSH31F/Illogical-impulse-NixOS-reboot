{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.applications;
in
{
  options.dotfiles.home.applications = {
    enable = lib.mkEnableOption "Application configurations";
  };

  config = lib.mkIf cfg.enable {
    # Fuzzel launcher
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "foot";
          layer = "overlay";
          font = "JetBrains Mono:size=12";
          dpi-aware = "yes";
          icon-theme = "Papirus-Dark";
          fields = "filename,name,generic";
          password-character = "*";
          filter-desktop = "yes";
          no-exit-on-keyboard-focus-loss = "yes";
        };
        
        colors = {
          background = "1e1e2edd";
          text = "cdd6f4ff";
          match = "f38ba8ff";
          selection = "585b70ff";
          selection-text = "cdd6f4ff";
          selection-match = "f38ba8ff";
          border = "b4befeff";
        };
        
        border = {
          width = 2;
          radius = 10;
        };
      };
    };

    # Foot terminal
    programs.foot = {
      enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "JetBrains Mono:size=12";
          dpi-aware = "yes";
          pad = "10x10";
        };
        
        mouse = {
          hide-when-typing = "yes";
        };
        
        colors = {
          alpha = "0.9";
          background = "1e1e2e";
          foreground = "cdd6f4";
          
          regular0 = "45475a";
          regular1 = "f38ba8";
          regular2 = "a6e3a1";
          regular3 = "f9e2af";
          regular4 = "89b4fa";
          regular5 = "f5c2e7";
          regular6 = "94e2d5";
          regular7 = "bac2de";
          
          bright0 = "585b70";
          bright1 = "f38ba8";
          bright2 = "a6e3a1";
          bright3 = "f9e2af";
          bright4 = "89b4fa";
          bright5 = "f5c2e7";
          bright6 = "94e2d5";
          bright7 = "a6adc8";
        };
      };
    };

    # Fish shell
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        
        # Custom functions
        function ll
            ls -alF $argv
        end
        
        function la
            ls -A $argv
        end
        
        function l
            ls -CF $argv
        end
        
        function ..
            cd ..
        end
        
        function ...
            cd ../..
        end
        
        function ....
            cd ../../..
        end
        
        # Git aliases
        function gs
            git status $argv
        end
        
        function ga
            git add $argv
        end
        
        function gc
            git commit $argv
        end
        
        function gp
            git push $argv
        end
        
        function gl
            git log --oneline $argv
        end
        
        # Hyprland specific
        function hypr-reload
            hyprctl reload
        end
        
        function wallpaper
            wallpaper-picker $argv
        end
        
        function theme
            theme-selector $argv
        end
      '';
      
      shellAliases = {
        grep = "grep --color=auto";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";
        ls = "ls --color=auto";
        dir = "dir --color=auto";
        vdir = "vdir --color=auto";
        ll = "ls -alF";
        la = "ls -A";
        l = "ls -CF";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };

    # Starship prompt
    programs.starship = {
      enable = true;
      settings = {
        format = "$all$character";
        
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
          style = "bold cyan";
        };
        
        git_branch = {
          symbol = " ";
          style = "bold purple";
        };
        
        git_status = {
          style = "bold yellow";
        };
        
        cmd_duration = {
          min_time = 500;
          format = "took [$duration](bold yellow)";
        };
        
        hostname = {
          ssh_only = false;
          format = "[$hostname](bold red) ";
          disabled = false;
        };
        
        username = {
          style_user = "bold blue";
          style_root = "bold red";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
      };
    };

    # MPV media player
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        force-window = true;
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };

    # Git configuration
    programs.git = {
      enable = true;
      userName = "t0psh31f";
      userEmail = "user@example.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "vim";
        pull.rebase = false;
      };
    };

    # Wlogout configuration
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
      
      style = ''
        * {
          background-image: none;
          box-shadow: none;
        }
        
        window {
          background-color: rgba(12, 12, 12, 0.9);
        }
        
        button {
          color: #FFFFFF;
          background-color: #1E1E1E;
          border-style: solid;
          border-width: 2px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border-radius: 10px;
          margin: 5px;
        }
        
        button:focus, button:active, button:hover {
          background-color: #3700B3;
          outline-style: none;
        }
        
        #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
        }
        
        #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
        }
        
        #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
        }
        
        #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
        }
        
        #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }
        
        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
      '';
    };

    # XDG configuration
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/Desktop";
        documents = "$HOME/Documents";
        download = "$HOME/Downloads";
        music = "$HOME/Music";
        pictures = "$HOME/Pictures";
        videos = "$HOME/Videos";
        templates = "$HOME/Templates";
        publicShare = "$HOME/Public";
      };
      
      mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
          "application/pdf" = "firefox.desktop";
          "image/jpeg" = "org.gnome.eog.desktop";
          "image/png" = "org.gnome.eog.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "audio/mpeg" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
        };
      };
    };

    # Qt theming
    qt = {
      enable = true;
      platformTheme = "qtct";
      style = {
        name = "kvantum";
        package = pkgs.libsForQt5.qtstyleplugin-kvantum;
      };
    };

    # GTK theming
    gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = [ "blue" ];
          size = "standard";
          tweaks = [ "rimless" "black" ];
          variant = "mocha";
        };
      };
      
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };
      
      font = {
        name = "Inter";
        size = 11;
      };
      
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    # Fontconfig
    fonts.fontconfig.enable = true;
  };
}
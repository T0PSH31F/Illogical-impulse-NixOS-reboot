{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.shell;
in
{
  options.dotfiles.home.shell = {
    enable = lib.mkEnableOption "Shell configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignoreDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
      };

      shellAliases = {
        # System
        ll = "eza -la --icons";
        ls = "eza --icons";
        la = "eza -a --icons";
        lt = "eza --tree --icons";
        cat = "bat";
        grep = "rg";
        find = "fd";
        
        # Git
        g = "git";
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git pull";
        gd = "git diff";
        gb = "git branch";
        gco = "git checkout";
        
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        
        # NixOS
        rebuild = "sudo nixos-rebuild switch --flake .";
        home-rebuild = "home-manager switch --flake .";
        update = "nix flake update";
        
        # System info
        ports = "netstat -tulanp";
        meminfo = "free -m -l -t";
        psmem = "ps auxf | sort -nr -k 4";
        pscpu = "ps auxf | sort -nr -k 3";
      };

      initExtra = ''
        # Starship prompt
        eval "$(starship init zsh)"
        
        # Zoxide
        eval "$(zoxide init zsh)"
        
        # FZF
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
        
        # Custom functions
        mkcd() {
          mkdir -p "$1" && cd "$1"
        }
        
        extract() {
          if [ -f $1 ] ; then
            case $1 in
              *.tar.bz2)   tar xjf $1     ;;
              *.tar.gz)    tar xzf $1     ;;
              *.bz2)       bunzip2 $1     ;;
              *.rar)       unrar e $1     ;;
              *.gz)        gunzip $1      ;;
              *.tar)       tar xf $1      ;;
              *.tbz2)      tar xjf $1     ;;
              *.tgz)       tar xzf $1     ;;
              *.zip)       unzip $1       ;;
              *.Z)         uncompress $1  ;;
              *.7z)        7z x $1        ;;
              *)     echo "'$1' cannot be extracted via extract()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        format = "$all$character";
        right_format = "$time";
        
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
        
        directory = {
          style = "bold cyan";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        
        git_branch = {
          style = "bold purple";
        };
        
        git_status = {
          style = "bold yellow";
        };
        
        time = {
          disabled = false;
          format = "[$time]($style)";
          style = "bold white";
        };
        
        nix_shell = {
          format = "via [$symbol$state( \($name\))]($style) ";
          symbol = "❄️ ";
          style = "bold blue";
        };
      };
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--border"
        "--layout=reverse"
        "--info=inline"
      ];
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
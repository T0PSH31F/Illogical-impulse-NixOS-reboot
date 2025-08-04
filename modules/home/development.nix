{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.development;
in
{
  options.dotfiles.home.development = {
    enable = lib.mkEnableOption "Development tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Version control
      git
      gh
      git-lfs
      
      # Languages and runtimes
      nodejs_20
      python3
      python3Packages.pip
      rustc
      cargo
      go
      
      # Build tools
      gnumake
      cmake
      pkg-config
      
      # Containers
      docker
      docker-compose
      podman
      
      # Database tools
      sqlite
      postgresql
      
      # Network tools
      postman
      insomnia
      
      # IDEs and editors
      vscode
      jetbrains.idea-community
      
      # Debugging and profiling
      gdb
      valgrind
      strace
      
      # Documentation
      man-pages
      man-pages-posix
      
      # Nix tools
      nixpkgs-fmt
      nil
      nix-tree
      nix-output-monitor
      
      # Other tools
      jq
      yq
      httpie
      mkcert
    ];

    programs.git = {
      enable = true;
      userName = "user";
      userEmail = "user@example.com";
      
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        pull.rebase = false;
        push.autoSetupRemote = true;
        
        # Better diffs
        diff.algorithm = "patience";
        diff.compactionHeuristic = true;
        
        # Reuse recorded resolution
        rerere.enabled = true;
        
        # Better merge conflict style
        merge.conflictstyle = "diff3";
        
        # Colors
        color.ui = "auto";
        color.branch.current = "yellow reverse";
        color.branch.local = "yellow";
        color.branch.remote = "green";
        color.diff.meta = "yellow bold";
        color.diff.frag = "magenta bold";
        color.diff.old = "red bold";
        color.diff.new = "green bold";
        color.status.added = "yellow";
        color.status.changed = "green";
        color.status.untracked = "cyan";
      };
      
      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        pushf = "push --force-with-lease";
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # Themes
        catppuccin.catppuccin-vsc
        
        # Languages
        ms-python.python
        rust-lang.rust-analyzer
        golang.go
        ms-vscode.cpptools
        bradlc.vscode-tailwindcss
        
        # Nix
        bbenoist.nix
        
        # Git
        eamodio.gitlens
        
        # Utilities
        ms-vscode.hexeditor
        ms-vsliveshare.vsliveshare
        esbenp.prettier-vscode
        ms-vscode.live-server
      ];
      
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.fontFamily" = "'JetBrains Mono', 'monospace'";
        "editor.fontSize" = 14;
        "editor.lineHeight" = 1.5;
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.scrollBeyondLastLine" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.rulers" = [ 80 120 ];
      };
    };
  };
}
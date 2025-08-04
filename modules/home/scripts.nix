{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.scripts;
  
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" ''
    #!/bin/bash
    
    WALLPAPER_DIR="$HOME/.local/share/wallpapers"
    
    if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Wallpaper directory not found: $WALLPAPER_DIR"
        exit 1
    fi
    
    # Use fuzzel to select wallpaper
    selected=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | \
               sed "s|$WALLPAPER_DIR/||" | \
               fuzzel --dmenu --prompt="Select wallpaper: ")
    
    if [ -n "$selected" ]; then
        wallpaper_path="$WALLPAPER_DIR/$selected"
        if [ -f "$wallpaper_path" ]; then
            swww img "$wallpaper_path" --transition-type wipe --transition-duration 2
            echo "Wallpaper set to: $selected"
            
            # Generate color scheme with matugen if available
            if command -v matugen >/dev/null 2>&1; then
                matugen image "$wallpaper_path" --mode dark --type scheme-content
            fi
        else
            echo "File not found: $wallpaper_path"
        fi
    fi
  '';
  
  theme-selector = pkgs.writeShellScriptBin "theme-selector" ''
    #!/bin/bash
    
    THEMES_DIR="$HOME/.config/themes"
    
    themes=("Catppuccin Mocha" "Catppuccin Macchiato" "Catppuccin Frappe" "Catppuccin Latte" "Material You Dark" "Material You Light")
    
    selected=$(printf '%s\n' "${themes[@]}" | fuzzel --dmenu --prompt="Select theme: ")
    
    case "$selected" in
        "Catppuccin Mocha")
            echo "Applying Catppuccin Mocha theme..."
            # Apply theme logic here
            ;;
        "Catppuccin Macchiato")
            echo "Applying Catppuccin Macchiato theme..."
            ;;
        "Catppuccin Frappe")
            echo "Applying Catppuccin Frappe theme..."
            ;;
        "Catppuccin Latte")
            echo "Applying Catppuccin Latte theme..."
            ;;
        "Material You Dark")
            echo "Applying Material You Dark theme..."
            ;;
        "Material You Light")
            echo "Applying Material You Light theme..."
            ;;
        *)
            echo "No theme selected or invalid selection"
            ;;
    esac
    
    # Reload Hyprland to apply changes
    hyprctl reload
  '';
  
  material-you = pkgs.writeShellScriptBin "material-you" ''
    #!/bin/bash
    
    if [ $# -eq 0 ]; then
        echo "Usage: material-you <image_path>"
        exit 1
    fi
    
    image_path="$1"
    
    if [ ! -f "$image_path" ]; then
        echo "Error: Image file not found: $image_path"
        exit 1
    fi
    
    echo "Generating Material You colors from: $image_path"
    
    # Generate colors with matugen
    if command -v matugen >/dev/null 2>&1; then
        matugen image "$image_path" --mode dark --type scheme-content
        echo "Material You colors generated successfully"
    else
        echo "Error: matugen not found. Please install matugen."
        exit 1
    fi
  '';
  
  quickshell-toggle = pkgs.writeShellScriptBin "quickshell-toggle" ''
    #!/bin/bash
    
    if pgrep -x "quickshell" > /dev/null; then
        echo "Stopping quickshell..."
        pkill quickshell
    else
        echo "Starting quickshell..."
        quickshell &
    fi
  '';
  
  hypr-screenshot = pkgs.writeShellScriptBin "hypr-screenshot" ''
    #!/bin/bash
    
    case "$1" in
        "area")
            grim -g "$(slurp)" - | swappy -f -
            ;;
        "screen")
            grim - | swappy -f -
            ;;
        "window")
            grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -
            ;;
        *)
            echo "Usage: hypr-screenshot [area|screen|window]"
            echo "  area   - Select area to screenshot"
            echo "  screen - Screenshot entire screen"
            echo "  window - Screenshot active window"
            ;;
    esac
  '';
  
  hypr-record = pkgs.writeShellScriptBin "hypr-record" ''
    #!/bin/bash
    
    RECORDINGS_DIR="$HOME/Videos/Recordings"
    mkdir -p "$RECORDINGS_DIR"
    
    case "$1" in
        "start")
            if pgrep -x "wf-recorder" > /dev/null; then
                echo "Recording already in progress"
                exit 1
            fi
            
            timestamp=$(date +"%Y%m%d_%H%M%S")
            output_file="$RECORDINGS_DIR/recording_$timestamp.mp4"
            
            if [ "$2" = "area" ]; then
                geometry=$(slurp)
                wf-recorder -g "$geometry" -f "$output_file" &
            else
                wf-recorder -f "$output_file" &
            fi
            
            echo "Recording started: $output_file"
            ;;
        "stop")
            if pgrep -x "wf-recorder" > /dev/null; then
                pkill -SIGINT wf-recorder
                echo "Recording stopped"
            else
                echo "No recording in progress"
            fi
            ;;
        *)
            echo "Usage: hypr-record [start|stop] [area]"
            echo "  start      - Start recording entire screen"
            echo "  start area - Start recording selected area"
            echo "  stop       - Stop recording"
            ;;
    esac
  '';
  
in
{
  options.dotfiles.home.scripts = {
    enable = lib.mkEnableOption "Custom scripts";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      wallpaper-picker
      theme-selector
      material-you
      quickshell-toggle
      hypr-screenshot
      hypr-record
    ];
    
    # Create desktop entries for scripts
    xdg.desktopEntries = {
      wallpaper-picker = {
        name = "Wallpaper Picker";
        comment = "Select and apply wallpapers";
        exec = "wallpaper-picker";
        icon = "preferences-desktop-wallpaper";
        categories = [ "Utility" "DesktopSettings" ];
      };
      
      theme-selector = {
        name = "Theme Selector";
        comment = "Select and apply themes";
        exec = "theme-selector";
        icon = "preferences-desktop-theme";
        categories = [ "Utility" "DesktopSettings" ];
      };
    };
  };
}
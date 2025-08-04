{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.terminal;
in
{
  options.dotfiles.home.terminal = {
    enable = lib.mkEnableOption "Terminal applications";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        # Font configuration
        font_family = "JetBrains Mono Nerd Font";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = 12;

        # Window settings
        window_padding_width = 10;
        window_margin_width = 0;
        window_border_width = 0;
        draw_minimal_borders = true;
        window_logo_path = "none";
        window_logo_position = "bottom-right";
        window_logo_alpha = "0.5";
        resize_debounce_time = "0.1";
        resize_in_steps = false;

        # Tab bar
        tab_bar_edge = "bottom";
        tab_bar_margin_width = "0.0";
        tab_bar_margin_height = "0.0 0.0";
        tab_bar_style = "powerline";
        tab_bar_align = "left";
        tab_bar_min_tabs = 2;
        tab_switch_strategy = "previous";
        tab_fade = "0.25 0.5 0.75 1";
        tab_separator = " ┇";
        tab_powerline_style = "slanted";
        tab_activity_symbol = "none";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

        # Color scheme (Material Theme)
        foreground = "#cdd6f4";
        background = "#1e1e2e";
        selection_foreground = "#1e1e2e";
        selection_background = "#f5e0dc";

        # Cursor colors
        cursor = "#f5e0dc";
        cursor_text_color = "#1e1e2e";

        # URL underline color when hovering with mouse
        url_color = "#f5e0dc";

        # Kitty window border colors
        active_border_color = "#b4befe";
        inactive_border_color = "#6c7086";
        bell_border_color = "#f9e2af";

        # OS Window titlebar colors
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";

        # Tab bar colors
        active_tab_foreground = "#11111b";
        active_tab_background = "#cba6f7";
        inactive_tab_foreground = "#cdd6f4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111b";

        # Colors for marks (marked text in the terminal)
        mark1_foreground = "#1e1e2e";
        mark1_background = "#b4befe";
        mark2_foreground = "#1e1e2e";
        mark2_background = "#cba6f7";
        mark3_foreground = "#1e1e2e";
        mark3_background = "#74c7ec";

        # The 16 terminal colors
        # black
        color0 = "#45475a";
        color8 = "#585b70";

        # red
        color1 = "#f38ba8";
        color9 = "#f38ba8";

        # green
        color2 = "#a6e3a1";
        color10 = "#a6e3a1";

        # yellow
        color3 = "#f9e2af";
        color11 = "#f9e2af";

        # blue
        color4 = "#89b4fa";
        color12 = "#89b4fa";

        # magenta
        color5 = "#f5c2e7";
        color13 = "#f5c2e7";

        # cyan
        color6 = "#94e2d5";
        color14 = "#94e2d5";

        # white
        color7 = "#bac2de";
        color15 = "#a6adc8";

        # Performance tuning
        repaint_delay = 10;
        input_delay = 3;
        sync_to_monitor = true;

        # Bell
        enable_audio_bell = false;
        visual_bell_duration = "0.0";
        window_alert_on_bell = true;
        bell_on_tab = true;
        command_on_bell = "none";

        # Mouse
        mouse_hide_wait = "3.0";
        url_style = "curly";
        open_url_with = "default";
        url_prefixes = "http https file ftp gemini irc gopher mailto news git";
        detect_urls = true;
        copy_on_select = false;
        strip_trailing_spaces = "never";
        select_by_word_characters = "@-./_~?&=%+#";
        click_interval = "-1.0";
        focus_follows_mouse = false;
        pointer_shape_when_grabbed = "arrow";
        default_pointer_shape = "beam";
        pointer_shape_when_dragging = "beam";

        # Terminal bell
        enable_audio_bell = false;
        visual_bell_duration = "0.0";

        # Advanced
        shell = "zsh";
        editor = "nvim";
        close_on_child_death = false;
        allow_remote_control = false;
        update_check_interval = 24;
        startup_session = "none";
        clipboard_control = "write-clipboard write-primary";
        allow_hyperlinks = true;
        shell_integration = "enabled";
      };

      keybindings = {
        # Clipboard
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+s" = "paste_from_selection";
        "shift+insert" = "paste_from_selection";
        "ctrl+shift+o" = "pass_selection_to_program";

        # Scrolling
        "ctrl+shift+up" = "scroll_line_up";
        "ctrl+shift+k" = "scroll_line_up";
        "ctrl+shift+down" = "scroll_line_down";
        "ctrl+shift+j" = "scroll_line_down";
        "ctrl+shift+page_up" = "scroll_page_up";
        "ctrl+shift+page_down" = "scroll_page_down";
        "ctrl+shift+home" = "scroll_home";
        "ctrl+shift+end" = "scroll_end";
        "ctrl+shift+h" = "show_scrollback";

        # Window management
        "ctrl+shift+enter" = "new_window";
        "ctrl+shift+n" = "new_os_window";
        "ctrl+shift+w" = "close_window";
        "ctrl+shift+]" = "next_window";
        "ctrl+shift+[" = "previous_window";
        "ctrl+shift+f" = "move_window_forward";
        "ctrl+shift+b" = "move_window_backward";
        "ctrl+shift+`" = "move_window_to_top";
        "ctrl+shift+r" = "start_resizing_window";
        "ctrl+shift+1" = "first_window";
        "ctrl+shift+2" = "second_window";
        "ctrl+shift+3" = "third_window";
        "ctrl+shift+4" = "fourth_window";
        "ctrl+shift+5" = "fifth_window";
        "ctrl+shift+6" = "sixth_window";
        "ctrl+shift+7" = "seventh_window";
        "ctrl+shift+8" = "eighth_window";
        "ctrl+shift+9" = "ninth_window";
        "ctrl+shift+0" = "tenth_window";

        # Tab management
        "ctrl+shift+right" = "next_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+q" = "close_tab";
        "ctrl+shift+." = "move_tab_forward";
        "ctrl+shift+," = "move_tab_backward";
        "ctrl+shift+alt+t" = "set_tab_title";

        # Layout management
        "ctrl+shift+l" = "next_layout";

        # Font sizes
        "ctrl+shift+equal" = "increase_font_size";
        "ctrl+shift+plus" = "increase_font_size";
        "ctrl+shift+minus" = "decrease_font_size";
        "ctrl+shift+backspace" = "restore_font_size";

        # Select and act on visible text
        "ctrl+shift+e" = "kitten hints";
        "ctrl+shift+p>f" = "kitten hints --type path --program -";
        "ctrl+shift+p>shift+f" = "kitten hints --type path";
        "ctrl+shift+p>l" = "kitten hints --type line --program -";
        "ctrl+shift+p>w" = "kitten hints --type word --program -";
        "ctrl+shift+p>h" = "kitten hints --type hash --program -";
        "ctrl+shift+p>n" = "kitten hints --type linenum";

        # Miscellaneous
        "ctrl+shift+f11" = "toggle_fullscreen";
        "ctrl+shift+f10" = "toggle_maximized";
        "ctrl+shift+u" = "kitten unicode_input";
        "ctrl+shift+f2" = "edit_config_file";
        "ctrl+shift+escape" = "kitty_shell window";
        "ctrl+shift+a>m" = "set_background_opacity +0.1";
        "ctrl+shift+a>l" = "set_background_opacity -0.1";
        "ctrl+shift+a>1" = "set_background_opacity 1";
        "ctrl+shift+a>d" = "set_background_opacity default";
        "ctrl+shift+delete" = "clear_terminal reset active";
      };
    };

    # Additional terminal tools
    home.packages = with pkgs; [
      # Terminal multiplexers
      tmux
      zellij
      
      # Terminal utilities
      btop
      htop
      neofetch
      tree
      fd
      ripgrep
      bat
      eza
      zoxide
      fzf
      
      # Network tools
      wget
      curl
      
      # Archive tools
      unzip
      zip
      p7zip
      
      # System tools
      lsof
      psmisc
      pciutils
      usbutils
    ];
  };
}
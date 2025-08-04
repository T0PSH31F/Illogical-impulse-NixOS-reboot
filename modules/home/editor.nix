{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.editor;
in
{
  options.dotfiles.home.editor = {
    enable = lib.mkEnableOption "Editor configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      
      extraPackages = with pkgs; [
        # Language servers
        lua-language-server
        nil
        nodePackages.typescript-language-server
        nodePackages.pyright
        rust-analyzer
        gopls
        
        # Formatters
        stylua
        nixpkgs-fmt
        nodePackages.prettier
        black
        rustfmt
        gofmt
        
        # Tools
        ripgrep
        fd
        tree-sitter
      ];

      plugins = with pkgs.vimPlugins; [
        # Core
        lazy-nvim
        
        # UI
        catppuccin-nvim
        lualine-nvim
        nvim-web-devicons
        indent-blankline-nvim
        
        # File management
        nvim-tree-lua
        telescope-nvim
        telescope-fzf-native-nvim
        
        # LSP
        nvim-lspconfig
        mason-nvim
        mason-lspconfig-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        luasnip
        cmp_luasnip
        
        # Treesitter
        nvim-treesitter.withAllGrammars
        nvim-treesitter-context
        
        # Git
        gitsigns-nvim
        fugitive
        
        # Utilities
        which-key-nvim
        comment-nvim
        nvim-autopairs
        toggleterm-nvim
        
        # Language specific
        rust-tools-nvim
        neodev-nvim
      ];

      extraLuaConfig = ''
        -- Basic settings
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.smartindent = true
        vim.opt.wrap = false
        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.opt.undofile = true
        vim.opt.hlsearch = false
        vim.opt.incsearch = true
        vim.opt.termguicolors = true
        vim.opt.scrolloff = 8
        vim.opt.signcolumn = "yes"
        vim.opt.isfname:append("@-@")
        vim.opt.updatetime = 50
        vim.opt.colorcolumn = "80"
        
        -- Leader key
        vim.g.mapleader = " "
        
        -- Colorscheme
        require("catppuccin").setup({
          flavour = "mocha",
          background = {
            light = "latte",
            dark = "mocha",
          },
          transparent_background = false,
          show_end_of_buffer = false,
          term_colors = false,
          dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
          },
          no_italic = false,
          no_bold = false,
          no_underline = false,
          styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
          },
          color_overrides = {},
          custom_highlights = {},
          integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = false,
            mini = false,
          },
        })
        
        vim.cmd.colorscheme "catppuccin"
        
        -- Keymaps
        local keymap = vim.keymap.set
        
        -- File explorer
        keymap("n", "<leader>pv", vim.cmd.Ex)
        
        -- Move lines
        keymap("v", "J", ":m '>+1<CR>gv=gv")
        keymap("v", "K", ":m '<-2<CR>gv=gv")
        
        -- Keep cursor centered
        keymap("n", "J", "mzJ`z")
        keymap("n", "<C-d>", "<C-d>zz")
        keymap("n", "<C-u>", "<C-u>zz")
        keymap("n", "n", "nzzzv")
        keymap("n", "N", "Nzzzv")
        
        -- Paste without losing register
        keymap("x", "<leader>p", [["_dP]])
        
        -- Copy to system clipboard
        keymap({"n", "v"}, "<leader>y", [["+y]])
        keymap("n", "<leader>Y", [["+Y]])
        
        -- Delete without yanking
        keymap({"n", "v"}, "<leader>d", [["_d]])
        
        -- Replace word under cursor
        keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
        
        -- Make file executable
        keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
      '';
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
      extraPackages = epkgs: with epkgs; [
        use-package
        evil
        evil-collection
        general
        which-key
        ivy
        counsel
        swiper
        company
        flycheck
        magit
        projectile
        treemacs
        doom-themes
        doom-modeline
        rainbow-delimiters
        org
        org-roam
        markdown-mode
        nix-mode
        rust-mode
        go-mode
        typescript-mode
        web-mode
      ];
    };

    # Copy material theme for Emacs
    home.file.".emacs.d/themes/material-theme.el".source = ../../Extras/emacs/material-theme.el;
  };
}
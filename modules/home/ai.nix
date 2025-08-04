{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles.home.ai;
in
{
  options.dotfiles.home.ai = {
    enable = lib.mkEnableOption "AI and machine learning tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # AI Chat interfaces
      chatgpt-cli
      
      # Python ML packages
      python3Packages.numpy
      python3Packages.pandas
      python3Packages.matplotlib
      python3Packages.seaborn
      python3Packages.scikit-learn
      python3Packages.jupyter
      python3Packages.ipython
      
      # Development tools
      python3Packages.pip
      python3Packages.virtualenv
      python3Packages.poetry
      
      # Text processing
      python3Packages.nltk
      python3Packages.spacy
      
      # Image processing
      python3Packages.pillow
      python3Packages.opencv4
      
      # Data formats
      python3Packages.requests
      python3Packages.beautifulsoup4
      python3Packages.lxml
      
      # Notebook tools
      jupyter
      
      # GPU acceleration (if available)
      # python3Packages.torch
      # python3Packages.tensorflow
    ];

    # Jupyter configuration
    programs.jupyter = {
      enable = true;
      kernels = {
        python3 = {
          displayName = "Python 3";
          argv = [
            "${pkgs.python3.withPackages (ps: with ps; [ ipykernel numpy pandas matplotlib ])}/bin/python"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
      };
    };

    # Environment for AI development
    home.sessionVariables = {
      JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
      JUPYTER_DATA_DIR = "${config.xdg.dataHome}/jupyter";
    };
  };
}
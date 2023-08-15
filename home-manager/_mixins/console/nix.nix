{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      alejandra
      any-nix-shell
      cached-nix-shell
      deadnix
      nix-index
      statix
      nixpkgs-fmt
      nurl
      rnix-lsp
      nil
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}

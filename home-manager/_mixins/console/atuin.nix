{ pkgs, ... }: {
  programs = {
    atuin = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
      package = pkgs.unstable.atuin;
      settings = {
        auto_sync = true;
        dialect = "us";
        search_mode = "compact";
        show_preview = true;
        sync_frequency = "1h";
        sync_address = "https://api.atuin.sh";
        update_check = false;
      };
    };
  };
}

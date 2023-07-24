{ pkgs, config, ... }: {
  home = {
    packages = [ pkgs.htop ];
    file = {
      xdg.configFile."htop/htoprc" = builtins.readFile ../../../assets/htop/htoprc;
    };
  };

}

{ pkgs, config, ... }: {
  home = {
    packages = [ pkgs.htop ];
    file = {
      "${config.xdg.configHome}/.config/htop/htoprc".text =
        builtins.readFile ../../../assets/htop/htoprc;
    };
  };

}

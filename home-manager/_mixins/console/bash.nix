_: {
    programs.bash = {
    enable = true;
    shellAliases = aliases;
    initExtra = ''
      ${functions}
      if [[ -d "${config.home.homeDirectory}/.asdf/" ]]; then
        . "${config.home.homeDirectory}/.asdf/asdf.sh"
        . "${config.home.homeDirectory}/.asdf/completions/asdf.bash"
      fi
    '';
  };
}
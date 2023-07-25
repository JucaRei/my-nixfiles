{ pkgs, ... }: {
  home.packages = with pkgs;[
    hunspell # Required for spellcheck
    hunspellDicts.pt_BR # American English spellcheck dictionary
    languagetool # spelling, style. and grammer checker
    libreoffice-fresh
  ];
}

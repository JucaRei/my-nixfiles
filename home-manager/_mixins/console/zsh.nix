{ pkgs, inputs, config, ... }:
#let
#  prompt = pkgs.writeShellScriptBin "prompt" ''${builtins.readFile ../../../assets/zsh/prompt.zsh }'';
#  kubectl = pkgs.writeShellScriptBin "kubectl" ''${builtins.readFile ../../../assets/zsh/kubectl.zsh }'';
#in
{
  home = {
    packages = [ pkgs.zsh ];
    file = {
      "prompt.zsh".source = ../../../assets/zsh/prompt.zsh;
      "kubeclt.zsh".source = ../../../assets/zsh/prompt.zsh;
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
    };
  };
}

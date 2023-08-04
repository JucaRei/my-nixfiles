{ pkgs, inputs, config, ... }:
#let
#  prompt = pkgs.writeShellScriptBin "prompt" ''${builtins.readFile ../../../assets/zsh/prompt.zsh }'';
#  kubectl = pkgs.writeShellScriptBin "kubectl" ''${builtins.readFile ../../../assets/zsh/kubectl.zsh }'';
#in
{
  home = {
    packages = [ pkgs.zsh ];
    "${config.xdg.configHome}/*.zshrc".text = builtins.readFile ../../../assets/zsh;
  };

  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
    };
  };
}

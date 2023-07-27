{ pkgs, inputs, config, ... }:
let
  prompt = pkgs.writeShellScriptBin "prompt" ''${builtins.readFile ../../../assets/zsh/prompt.zsh }'';
  kubectl = pkgs.writeShellScriptBin "kubectl" ''${builtins.readFile ../../../assets/zsh/kubectl.zsh }'';
in
{
  home.packages = with pkgs; [
    prompt
    kubectl
  ];
  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
    };
  };
}

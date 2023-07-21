#
#  Editors
#
#  flake.nix
#   ├─ ./machines
#   │   └─ ./home.nix
#   ├─ ./nixpmanager
#   │   └─ ./home.nix
#   └─ ./modules
#       └─ ./services
#           └─ default.nix *
#               └─ ...
#

_: {
  imports = [
    ./nvim
    ./emacs/doom-emacs
  ];
  # Comment out emacs if you are not using native doom emacs. (import from host configuration.nix)

}

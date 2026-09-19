{ selfpkgs, pkgs }:

with pkgs;
[
  selfpkgs.my-git

  fish
  starship

  fd
  fzf
  ripgrep
  zoxide

  bat
  eza
  yazi
  tree

  delta
  lazygit

  jq
  yq-go

  nh
  nix-output-monitor
  dix

  btop
  dust
  duf
  tldr
]

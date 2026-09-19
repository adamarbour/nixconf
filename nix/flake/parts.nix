{ inputs, ... }:
{
  imports = with inputs; [
    flake-parts.flakeModules.modules
    devshell.flakeModule
    disko.flakeModules.default
    git-hooks-nix.flakeModule
    nix-topology.flakeModule
    treefmt-nix.flakeModule
    wrapper-modules.flakeModules.wrappers
  ];
}

{ inputs, ... }:
{
    imports = with inputs; [
        flake-parts.flakeModules.modules
        # others...
        devshell.flakeModule
        disko.flakeModules.default
        wrapper-modules.flakeModules.wrappers
    ];
}

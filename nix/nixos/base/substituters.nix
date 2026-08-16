{
    flake.modules.nixos.base = {
        nix.settings.substituters = [
          # high priority since it's almost always used
          "https://cache.nixos.org?priority=10"
          "https://install.determinate.systems"
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian"
        ];

        nix.settings.trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM"
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        ];
    };
}

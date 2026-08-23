 { self, ... }:
 {
  flake.modules.nixos.graphical = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      graphics
      adam
    ];

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font" ];
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };

    services.power-profiles-daemon.enable = true;
  };
}

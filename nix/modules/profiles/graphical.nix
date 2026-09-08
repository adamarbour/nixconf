{ self, ... }:
{
  flake.modules.nixos.graphical = { pkgs, lib, ... }: {
    imports = with self.modules.nixos; [
      has-audio
      has-graphics
      has-ssh-agent
      has-yubikey
      policy-polkit
      policy-u2f-yubikey
      ghostty
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

    my.programs = {
      direnv.enable = true;
    };

    wrappers = {
      ghostty.enable = lib.mkDefault true;
    };

    my.services.nebula.canSign = true;
  };
}

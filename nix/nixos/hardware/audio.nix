{
  flake.modules.nixos.hw-audio = { pkgs, ...}: {
    security.rtkit.enable = true;

    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
        extraConfig = {
          "10-default-quantum" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 2048;
            };
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
      easyeffects
      qpwgraph
      playerctl
    ];
  };
}

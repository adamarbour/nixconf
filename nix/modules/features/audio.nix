{
  flake.modules.nixos.has-audio = { lib, ... }: {
    security.rtkit.enable = lib.mkDefault true;

    services.pipewire = {
      enable = lib.mkDefault true;
      audio.enable = lib.mkDefault true;

      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      jack.enable = lib.mkDefault true;

      wireplumber.enable = lib.mkDefault true;
    };
  };
}

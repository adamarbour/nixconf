{ inputs, self, ... }:
{
  flake.modules.nixos.graphical = { pkgs, ... }: {
    boot.plymouth = {
      enable = true;
      theme = "bgrt";
    };

    boot.kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "rd.systemd.show_status=auto"
      "vt.global_cursor_default=0"
    ];
  };
}

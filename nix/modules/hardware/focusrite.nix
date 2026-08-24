{ self, ... }:
{
  flake.modules.nixos.hw-focusrite-scarlett = { lib, ... }: {
    imports = with self.modules.nixos; [
      has-audio
    ];

    services = {
      udev.extraRules = lib.mkAfter ''
        ACTION=="add", \
          SUBSYSTEM=="usb", \
          ATTR{idVendor}=="1235", \
          ATTR{idProduct}=="8218", \
          TEST=="power/control", \
          ATTR{power/control}="on"
      '';

      pipewire.wireplumber.extraConfig."50-focusrite-scarlett" = {
        "wireplumber.settings" = {
          "node.restore-default-targets" = false;
        };

        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_output.usb-Focusrite_Scarlett_Solo.*";
              }
            ];

            actions.update-props = {
              "node.description" = "Scarlett Solo";
              "priority.session" = 1400;
            };
          }

          {
            matches = [
              {
                "node.name" = "~alsa_input.usb-Focusrite_Scarlett_Solo.*";
              }
            ];

            actions.update-props = {
              "node.description" = "Scarlett Solo";
              "priority.session" = 2500;
            };
          }
        ];
      };
    };
  };
}

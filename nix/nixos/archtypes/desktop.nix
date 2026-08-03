{ inputs, self, ... }:
{
    flake.modules.nixos.desktop = {
        inputs = [
            self.modules.nixos.base
            self.modules.nixos.audio
        ];

        # Lower-latency quantum for the interface — desktop has CPU headroom
        services.pipewire.wireplumber.extraConfig."51-scarlett-latency" = {
            "monitor.alsa.rules" = [
            {
                matches = [{ "node.name" = "~alsa_output.usb-Focusrite.*"; }];
                actions.update-props = {
                    "audio.rate" = 48000;
                    "api.alsa.period-size" = 128;
                };
            }
            ];
        };
        services.pipewire.wireplumber.extraConfig."52-scarlett-default" = {
            "monitor.alsa.rules" = [
            {
                matches = [{ "node.name" = "~alsa_output.usb-Focusrite.*"; }];
                actions.update-props."priority.session" = 2000;
            }
            ];
        };
    };
}

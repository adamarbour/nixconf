{ inputs, self, ... }:
{
    flake.modules.nixos.laptop = {
        imports = [
            self.modules.nixos.base
            self.modules.nixos.graphical
            self.modules.nixos.audio
        ];

        # audio
        services.pipewire.wireplumber.extraConfig."53-laptop-power" = {
            "context.properties" = {
            "default.clock.quantum" = 2048;
            };
        };
        services.pipewire.wireplumber.extraConfig."54-idle-suspend" = {
            "monitor.alsa.rules" = [
            {
                matches = [{ "node.name" = "~alsa_output.*"; }];
                actions.update-props."session.suspend-timeout-seconds" = 5;
            }
            ];
        };

        # network
        services.openssh.openFirewall = false;
    };
}

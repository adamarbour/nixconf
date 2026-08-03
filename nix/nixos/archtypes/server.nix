{ inputs, self, ... }:
{
    flake.modules.nixos.server = {
        imports = [
            self.modules.nixos.base
        ];

        # network
        services.openssh = {
            ports = [ 2413 ]; # personal preference for public facing port.
            openFirewall = true;
            settings.AllowUsers = [ "adam" ];
        };
        services.fail2ban = {
            enable = true;
            maxretry = 4;
            bantime = "1h";
            bantime-increment.enable = true;
        };
    };
}

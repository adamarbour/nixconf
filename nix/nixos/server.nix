{ inputs, self, ... }:
{
    flake.modules.nixos.server = { lib, ... }: {
        imports = [
            self.modules.nixos.base
        ];

        # locale
        time.timeZone = lib.mkForce "UTC";

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

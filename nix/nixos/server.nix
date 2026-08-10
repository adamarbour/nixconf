{ inputs, self, ... }:
{
    flake.modules.nixos.server = { lib, ... }: {
        imports = [
            self.modules.nixos.base
        ];
        services.fail2ban = {
            enable = true;
            maxretry = 4;
            bantime = "1h";
            bantime-increment.enable = true;
        };
    };
}

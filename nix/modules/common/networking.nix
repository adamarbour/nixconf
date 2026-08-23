{
  flake.modules.nixos.common = { lib, config, ... }: {
    networking = {
      hostId =
        if config.boot.zfs.enabled then
          "8425e349"
        else
          builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
      useDHCP = lib.mkDefault false;

      enableIPv6 = true;

      nameservers = [
        "45.90.28.0#${config.networking.hostName}--88bdf4.dns.nextdns.io"
        "2a07:a8c0::#${config.networking.hostName}--88bdf4.dns.nextdns.io"
        "45.90.30.0#${config.networking.hostName}--88bdf4.dns.nextdns.io"
        "2a07:a8c1::#${config.networking.hostName}--88bdf4.dns.nextdns.io"
      ];
    };

    services.resolved = {
      enable = true;
      settings.Resolve = {
        DNS = config.networking.nameservers;
        DNSOverTLS = "yes";
        DNSSEC = "allow-downgrade";
        Domains = [ "~." ];
        LLMNR = "no";
      };
    };
  };
}

{
  flake.modules.nixos.base = { lib, config, ... }: {

    networking = {
      hostId = if (config.boot.zfs.enabled) then "8425e349" else builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);
      useDHCP = lib.mkForce false;
      usePredictableInterfaceNames = lib.mkDefault true;

      enableIPv6 = true;

      nameservers = [
        "45.90.28.0#88bdf4.dns.nextdns.io"
        "2a07:a8c0::#88bdf4.dns.nextdns.io"
        "45.90.30.0#88bdf4.dns.nextdns.io"
        "2a07:a8c1::#88bdf4.dns.nextdns.io"
      ];
    };

    services.resolved = {
      enable = true;
      settings.Resolve.LLMNR = "resolve";
      settings.Resolve.DNSOverTLS = true;
    };

  };
}

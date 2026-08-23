{
  flake.modules.nixos.common = { lib, config, ... }: {
    networking.timeServers = [
      "time.cloudflare.com"
      "time.google.com"
      "time.nist.gov"
    ];

    services = {
      timesyncd.enable = lib.mkDefault config.boot.isContainer;
      chrony.enable = lib.mkDefault (!config.boot.isContainer);
    };
  };
}

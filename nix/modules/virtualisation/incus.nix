{
  flake.modules.nixos.incus = { lib, ... }: {
    networking.nftables.enable = lib.mkForce true;

    virtualisation.incus = {
      enable = true;
      preseed = {
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            config = {
              "ipv4.address" = "10.251.0.1/24";
              "ipv4.nat" = "true";
              "ipv6.address" = "none";
            };
          }
        ];

        storage_pools = [
          {
            name = "default";
            drive = "dir";
          }
        ];

        profiles = [
          {
            name = "default";
            devices = {
              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
            };
          }
        ];
      };
    };
  };
}

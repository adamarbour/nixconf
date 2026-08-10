{
  flake.modules.nixos.server = { lib, ... }: {

    networking = {
      firewall = {
        # allow servers to be pinnged, but not our clients
        allowPing = lib.mkForce true;
      };
    };

  };
}

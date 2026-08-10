{
  flake.modules.nixos.server = {
    services.openssh = {
      ports = [ 2413 ]; # personal preference for public facing port.
    };
  };
}

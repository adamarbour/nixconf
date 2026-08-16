{
  flake.modules.nixos.print-pdf = { lib, ... }: {

    services.printing.cups-pdf.enable = lib.mkDefault true;

  };
}

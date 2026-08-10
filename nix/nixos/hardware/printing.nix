{
  flake.modules.nixos.printing = { pkgs, lib, config, ...}: {

    services.printing = {
      enable = true;
      webInterface = config.services.printing.enable;
      browsing = lib.mkDefault true;
      allowFrom = [ "localhost" ];

      cups-pdf.enable = true;

      drivers = with pkgs; [
        gutenprint
        cnijfilter2
      ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };

  };
}

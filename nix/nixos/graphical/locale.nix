{
  flake.modules.nixos.graphical = {

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

  };
}

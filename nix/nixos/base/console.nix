{
  flake.modules.nixos.base = { pkgs, lib, ... }: {
    console = {
      enable = lib.mkDefault true;
      earlySetup = true;

      keyMap = "en";
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v28n.psf.gz";
    };
  };
}

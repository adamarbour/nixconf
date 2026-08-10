{
  flake.modules.nixos.base = { pkgs, lib, ... }: {

    # its nice to have at least some color in our tty
    systemd.services."serial-getty@".environment.TERM = "xterm-256color";

    console = {
      enable = lib.mkDefault true;
      earlySetup = true;

      keyMap = "en";
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v28n.psf.gz";
    };
  };
}

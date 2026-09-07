{
  flake.modules.nixos.has-ssh-agent = { lib, pkgs, ... }: {
    services.udev.packages = [ pkgs.libfido2 ];
    environment.systemPackages = [ pkgs.libfido2 ];

    programs.ssh.startAgent = lib.mkDefault true;
  };
}

{
  flake.modules.nixos.hw-tpm = { pkgs, ...}: {

    boot.initrd.kernelModules = [ "tpm" ];

    security.tpm2 = {
      enable = true;
      tctiEnvironment.enable = true;
      pkcs11.enable = true;
    };

  };
}

{
  flake.modules.nixos = {
    hw-gpu-amd = { lib, ... }: {
      hardware = {
        graphics.enable = lib.mkDefault true;

        amdgpu = {
          initrd.enable = lib.mkDefault true;
          opencl.enable = lib.mkDefault true;
          zluda.enable = lib.mkDefault false;
        };
      };
      services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];
    };

    hw-gpu-intel = { pkgs, lib, ... }: {
      boot.initrd.kernelModules = lib.mkBefore [ "i915" ];
      hardware.graphics = {
        enable = lib.mkDefault true;
        extraPackages = lib.mkAfter [
          pkgs.intel-media-driver
          pkgs.intel-compute-runtime
          (pkgs.vpl-gpu-rt or pkgs.onevpl-intel-gpu)
        ];
      };
      services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
    };

    hw-gpu-nvidia = { lib, ... }: {
      hardware = {
        graphics.enable = lib.mkDefault true;

        nvidia = {
          branch = lib.mkDefault "latest";
          open = lib.mkDefault false;
          modesetting.enable = lib.mkDefault true;
          nvidiaSettings = lib.mkDefault false;
        };
      };
      services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
    };

    hw-gpu-nvidia-prime = { lib, ... }: {
      hardware.nvidia = {
        branch = lib.mkDefault "stable";
        open = lib.mkDefault false;
        nvidiaSettings = lib.mkDefault false;
        powerManagement.enable = lib.mkDefault true;

        prime.offload = {
          enable = true;
          enableOffloadCmd = lib.mkDefault true;
        };
      };
      services.xserver.videoDrivers = lib.mkAfter [ "nvidia" ];
    };
  };
}

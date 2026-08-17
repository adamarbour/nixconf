{
  flake.modules.nixos.gpu-prime = { pkgs, lib, config, ... }: {
    hardware.nvidia = {
      powerManagement = {
        enable = true;
        finegrained = false;
      };

      open = lib.mkDefault false;
      nvidiaSettings = lib.mkDefault false;

      prime = {
        sync.enable = lib.mkForce false;
        offload  = {
          enable = lib.mkOverride 990 true;
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
        };
      };
    };

    environment.systemPackages = [
      pkgs.nvtopPackages.nvidia
      # vulkan
      pkgs.vulkan-tools
      pkgs.vulkan-loader
      pkgs.vulkan-validation-layers
      pkgs.vulkan-extension-layer
      # libva
      pkgs.libva
      pkgs.libva-utils
    ];
  };

  flake.modules.nixos.gpu-intel = { pkgs, ... }: {
    boot.initrd.kernelModules = [ "i915" ];
    boot.kernelParams = [ "i915.fastboot=1" ];

    services.xserver.videoDrivers = [ "modesetting" ];

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
      ];
    };
  };

  flake.modules.nixos.gpu-amd = { pkgs, ... }: {
    boot.kernelModules = [ "amdgpu" ];

    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };

  flake.modules.nixos.gpu-nvidia = { pkgs, lib, ... }: {
    boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia_drm.modeset=1" ];
    boot.blacklistedKernelModules = [ "nouveau" ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware = {
      nvidia = {
        branch = "bleeding_edge";

        powerManagement = {
          enable = true;
          finegrained = false;
        };

        open = lib.mkDefault false;
        nvidiaSettings = lib.mkDefault false;
      };
      graphics = {
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
        extraPackages32 = [ pkgs.pkgsi686Linux.nvidia-vaapi-driver ];
      };
    };

    environment.systemPackages = [
      pkgs.nvtopPackages.nvidia
      # vulkan
      pkgs.vulkan-tools
      pkgs.vulkan-loader
      pkgs.vulkan-validation-layers
      pkgs.vulkan-extension-layer
      # libva
      pkgs.libva
      pkgs.libva-utils
    ];
  };
}

{ inputs, self, ... }:
{
    flake.modules.nixos.hellespont = { pkgs, ... }: {
        imports = [
            # profiles
            self.modules.nixos.desktop
            self.modules.nixos.gaming

            # hardware
            self.modules.nixos.hw-tpm
            self.modules.nixos.cpu-amd
            self.modules.nixos.gpu-amd
            self.modules.nixos.printing
            self.modules.nixos.yubikey

            # software
            self.modules.nixos.boot-secure
        ];

        # Use latest kernel.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        # Enable the X11 windowing system.
        # You can disable this if you're only using the Wayland session.
        services.xserver.enable = true;

        # Enable the KDE Plasma Desktop Environment.
        services.displayManager.sddm.enable = true;
        services.desktopManager.plasma6.enable = true;

        programs.firefox.enable = true;

    };

    flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "hellespont";
}

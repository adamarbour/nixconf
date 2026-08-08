{ inputs, self, ... }:
{
    flake.modules.nixos.hyphasis = { pkgs, ... }: {
        imports = [
            # baseline
            self.modules.nixos.desktop
            # hardware
            self.modules.nixos.yubikey
            # software
        ];

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Use latest kernel.
        boot.kernelPackages = pkgs.linuxPackages_latest;

        networking.networkmanager.enable = true;

        # Enable the X11 windowing system.
        services.xserver.enable = true;

        # Enable the XFCE Desktop Environment.
        services.xserver.displayManager.lightdm.enable = true;
        services.xserver.desktopManager.xfce.enable = true;

        # Enable CUPS to print documents.
        services.printing.enable = true;

        programs.firefox.enable = true;

        environment.systemPackages = with pkgs; [
            git
            github-cli
        ];
    };

    flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "hyphasis";
}

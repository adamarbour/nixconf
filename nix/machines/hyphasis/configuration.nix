{ inputs, self, ... }:
{
    flake.modules.nixos.hyphasis = { pkgs, lib, ... }: {
        imports = [
            # baseline
            self.modules.nixos.desktop
            self.modules.nixos.gaming

            # hardware
            self.modules.nixos.hw-tpm
            self.modules.nixos.cpu-intel
            self.modules.nixos.gpu-intel
            self.modules.nixos.gpu-prime # nvidia RTX 500
            self.modules.nixos.printing
            self.modules.nixos.print-pdf
            self.modules.nixos.yubikey

            # disko
            inputs.disko.nixosModules.disko
            self.diskoConfigurations.hyphasis

            # software
            self.modules.nixos.boot-systemd
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

        # TEMPORARY BOOT DIAGNOSTICS — remove once the reboot-loop is understood.
        # Machine reboots almost immediately instead of reaching the LUKS prompt.
        # "oops=panic" (base/security.nix) escalates any oops to a hard panic, and
        # "quiet" + plymouth (graphical/boot-silent.nix) suppress console text, so
        # right now we can't see why. This forces verbose, non-panicking boot so
        # the real error is visible on screen.
        boot.plymouth.enable = lib.mkForce false;
        boot.kernelParams = lib.mkForce [
            "nowatchdog"
            "nmi_watchdog=0"
            "boot.shell_on_fail"
            "systemd.log_level=debug"
            "rd.systemd.show_status=yes"
            "rd.udev.log_level=debug"
        ];
    };

    flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "hyphasis";
}

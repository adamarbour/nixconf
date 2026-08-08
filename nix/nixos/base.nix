{ inputs, self, ... }:
{
    flake.modules.nixos.base = { pkgs, lib, config, ... }: {

        imports = [
            # inputs
            inputs.hjem.nixosModules.default
            # self
            self.modules.nixos.user-adam
        ];

        # packages
        environment.systemPackages = with pkgs; [
            # development
            git
        ];

        # locale
        time.timeZone = lib.mkDefault "America/Chicago";

        services.xserver.xkb = {
            layout = "us";
            variant = "";
        };

        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
        };

        # nix settings

        # https://github.com/NixOS/nixpkgs/blob/eca4605163a534aed1981de0f5f1d7d7639d1640/nixos/modules/programs/environment.nix#L18
        environment.variables.NIXPKGS_CONFIG = lib.mkForce "";

        nix.registry.nixpkgs.flake = inputs.nixpkgs;
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        nix.channel.enable = false;
        nix.optimise = {
            automatic = true;
            dates = [ "weekly" ];
        };
        nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
        };

        nix.settings = {

            trusted-users = [ "root" "@wheel" ];

            download-buffer-size = 1024 * 1024 * 1024;
            min-free = 5 * 1024 * 1024 * 1024;
            max-free = 20 * 1024 * 1024 * 1024;

            experimental-features = [
                "nix-command"
                "flakes"
                "auto-allocate-uids"
                "cgroups"
                "git-hashing"
            ];

            sandbox = pkgs.stdenv.hostPlatform.isLinux;

            max-jobs = "auto";

            keep-going = true;
            log-lines = 30;

            use-registries = true;
            flake-registry = "";

            warn-dirty = false;
            http-connections = 50;

            keep-derivations = true;
            keep-outputs = true;

            use-xdg-base-directories = true;

            accept-flake-config = false;
        };

        nixpkgs.config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
            allowVariants = true;
            allowBroken = false;
            permittedInsecurePackages = [];
            allowUnsupportedSystem = false;
            allowAliases = false;
        };

        nixpkgs.overlays = [
            (final: _prev: {
                stable = import inputs.nixpkgs-stable {
                    inherit (final) config;
                    system = pkgs.stdenv.hostPlatform.system;
                };
                unstable = import inputs.nixpkgs-unstable {
                    inherit (final) config;
                    system = pkgs.stdenv.hostPlatform.system;
                };
            })
        ];

        # security
        environment.etc = {
            # Empty /etc/securetty to prevent root login on tty.
            securetty.text = ''
            # /etc/securetty: list of terminals on which root is allowed to login.
            # See securetty(5) and login(1).
            '';

            # Set machine-id to the Kicksecure machine-id, for privacy reasons.
            # /var/lib/dbus/machine-id doesn't exist on dbus enabled NixOS systems,
            # so we don't have to worry about that.
            machine-id.text = ''
            b08dfa6083e7567a1921a715000001fb
            '';
        };

        # boot
        boot = {
            loader.timeout = lib.mkDefault 3;
            loader.systemd-boot.editor = lib.mkDefault false;
            consoleLogLevel = 3;
            initrd.verbose = false;

            kernelParams = [
                "nowatchdog"
                "nmi_watchdog=0"
            ];

            tmp = {
                useTmpfs = lib.mkDefault true;
                tmpfsHugeMemoryPages = lib.mkDefault "within_size";
                cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
            };
        };

        system.stateVersion = "26.05";

    };
}

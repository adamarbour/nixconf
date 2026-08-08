{ inputs, ... }:
{
    flake.modules.nixos.base = { pkgs, lib, ... }: {
        programs.ssh = {
            hostKeyAlgorithms = [ "ssh-ed25519" "rsa-sha2-512" ];
            extraConfig = ''
                HashKnownHosts yes
                VisualHostKey yes
            '';
        };
        services.openssh = {
            enable = true;
            allowSFTP = true;
            settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
                PermitRootLogin = "no";
                PubkeyAuthentication = true;
                X11Forwarding = false;

                KexAlgorithms = [
                    "mlkem768x25519-sha256"
                    "sntrup761x25519-sha512"
                    "curve25519-sha256"
                    "curve25519-sha256@libssh.org"
                ];
                Ciphers = [ "chacha20-poly1305@openssh.com" "aes256-gcm@openssh.com" "aes128-gcm@openssh.com" ];
                Macs = [ "hmac-sha2-512-etm@openssh.com" "hmac-sha2-256-etm@openssh.com" ];

                LogLevel = "VERBOSE";
            };
            hostKeys = [
                { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
            ];
            extraConfig = ''
                AuthenticationMethods publickey
            '';
        };
    };
}

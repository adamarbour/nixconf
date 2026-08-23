{
  flake.modules.nixos.common = { lib, ... }: {
    users.groups.ssh-login = { };

    persistence.files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];

    services.openssh = {
      enable = true;
      allowSFTP = true;

      openFirewall = true;
      ports = lib.mkDefault [ 22 ];

      settings = {
        AllowGroups = [ "ssh-login" ];

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
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
        ];

        # kick out inactive sessions
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        LogLevel = "VERBOSE";
      };

      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      extraConfig = ''
        AuthenticationMethods publickey
      '';
    };
  };
}

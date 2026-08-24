{ self, ... }:
{
  flake.modules.nixos.policy-u2f-yubikey =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (config.security) polkit;

      yubikeyAuth = {
        enable = true;
        control = "sufficient";
      };
    in
    {
      imports = with self.modules.nixos; [
        has-yubikey # ensure
      ];

      security = {
        pam = {
          # we do not want it set globally
          u2f = {
            enable = false;
            settings = {
              authfile = "/etc/u2f-mappings";

              origin = "pam://nixos";
              cue = true;
              userpresence = 1;
              pinverifcation = 1;
              userverification = 0;
            };
          };
          # set it for sudo
          services = lib.mkMerge [
            {
              sudo.u2f = yubikeyAuth;
              sudo-i.u2f = yubikeyAuth;
            }
            (lib.mkIf polkit.enable {
              polkit-1.u2f = yubikeyAuth;
            })
          ];
        };
      };

      systemd.services = lib.mkIf polkit.enable {
        "polkit-agent-helper@".serviceConfig = {
          PrivateDevices = false;

          DeviceAllow = [
            "/dev/urandom r"
            "char-hidraw rw"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        pam_u2f
      ];

      # declare my mappings in the policy
      environment.etc."u2f-mappings".text = ''
        adam:ktxWxvqDN2yBfWzd9ks6UUWr/M+RiCwKLYVNhZkUxPBEytdMTtRghpHJR6bQXxe3cG1dHU+i+cPB3eooYDbcaQ==,AkSdqZWpP4VUG0RxiREOzXdvF5pBHCR8Ar3kKRNL/+o4C8Jdb2DDjnd19iql25gnox1LP3O5SvztIsJTr58y1A==,es256,+presence+pin:B96CzZ3mQNDz1Zz0G5Coh4NNPNEaX2qEelIgbKvwQ30w93F+rE8swdgjxkseOrdhre2YO3pvAG5W5JMtvdJIXg==,6CbinGKKkAJlX3I/6xInfUB8gCUlcC4ZTS4n1DwIJ+5vM6LEg0zHW8bxCf/iDvgp/GFwaa+1FYG+3Boy8i7GVQ==,es256,+presence+pin
      '';
    };
}

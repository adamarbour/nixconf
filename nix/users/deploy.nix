{
  flake.modules.nixos.user-deploy = { pkgs, ... }: {

    users.users.deploy = {
      isSystemUser = true;
      group = "deploy";
      extraGroups = [
        "wheel"
        "ssh-login"
      ];
      shell = pkgs.bashInteractive;
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEQ3G00lHh4rexwd+spiN9gYwm9iqUn6NWXmjyHRdQT4"
      ];
    };
  };
}

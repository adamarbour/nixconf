{
  flake.modules.nixos.user-deploy = { pkgs, ... }: {

    users.users.deploy = {
      isSystemUser = true;
      group = "deploy";
      extraGroups = [ "ssh-login" ];
      shell = pkgs.bashInteractive;
      hashedPassword = "!";
    };
  };
}

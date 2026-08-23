{
  flake.modules.nixos.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {

      users.users.root = lib.mkMerge [
        {
          shell = lib.mkForce pkgs.bashInteractive;
        }

        (lib.mkIf (!config.nixSecrets.enable) {
          # Initial throwaway password: "nixos"
          initialHashedPassword = lib.mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
        })
        (lib.mkIf config.nixSecrets.enable {
          hashedPasswordFile = config.sops.secrets.passwd.path;
        })
      ];
    };
}

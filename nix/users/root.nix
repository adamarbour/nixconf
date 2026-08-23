{
  flake.modules.nixos.base = { pkgs, lib, ... }: {

    users.users.root = {
      shell = pkgs.bashInteractive;

      # Initial throwaway password: "nixos"
      initialHashedPassword = lib.mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    };

  };
}

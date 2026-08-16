{
  flake.modules.nixos.user-adam = { lib, ... }: {
    users.users = {
      "adam" = {
        isNormalUser = true;
        description = "Adam";
        extraGroups = [ "networkmanager" "wheel" ];

        # Initial throwaway password: "nixos"
        initialHashedPassword = lib.mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
      };
    };

    # TODO: come back and make this conditional ...
    hjem.users.adam = {
      enable = true;
      user = "adam";
      directory = "/home/adam";
      clobberFiles = true;
    };
  };
}

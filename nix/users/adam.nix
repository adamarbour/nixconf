{
  flake.modules.nixos.adam = { lib, ... }: {

    users.users.adam = {
      isNormalUser = true;
      description = "Adam";
      extraGroups = [ "networkmanager" "wheel" "deploy" "ssh-login" ];

      # Initial throwaway password: "nixos"
      initialHashedPassword = lib.mkDefault "$y$j9T$FbXu9/hYPFtVkAy.3JSCs1$XAgWbQs7MbNHP/jH3LRYoxzcwhpQAjY74U7fv40XO94";
    };

    hjem.users.adam = {
      enable = true;
      user = "adam";
      directory = "/home/adam";
      clobberFiles = true;
    };

  };
}

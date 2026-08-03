{
    flake.modules.nixos.user-adam = {
        users.users = {
            "adam" = {
                isNormalUser = true;
                description = "Adam";
                extraGroups = [ "networkmanager" "wheel" ];
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

{ inputs, self, ... }:
{
    flake.modules.nixos.server = {
        inputs = [
            self.modules.nixos.base
        ];
    };
}

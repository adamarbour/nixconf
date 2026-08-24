{ self, ... }:
{
  flake.modules.nixos.policy-polkit = {
    imports = with self.modules.nixos; [
      has-polkit
    ];
  };
}

{ self, ... }:
{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
      common
      my-programs # bring in default programs and options
      has-sops # secrets enabled by default
      policy-security-baseline
    ];
  };
}

{ self, ... }:
{
  flake.modules.nixos.base = {
    imports = with self.modules.nixos; [
      common
      my-programs
      my-services
      has-sops # secrets enabled by default
      policy-security-baseline
    ];

    # base services
    my.services = {
      # nebula for backplane everywhere
      nebula.enable = true;
    };
  };
}

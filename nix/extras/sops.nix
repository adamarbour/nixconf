{ inputs, ... }:
{
  flake.modules.nixos.sops = { lib, ... }: {
    imports = with inputs; [
      sops-nix.nixosModules.sops
    ];

    options.nixSecrets.root = lib.mkOption {
      type = lib.types.pathInStore;
      readOnly = true;
      default = inputs.my-secrets;
      description = "Root of the encrypted secrets repository.";
    };
  };
}

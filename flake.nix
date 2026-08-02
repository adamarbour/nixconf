{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # others...
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # import all .nix files from nix folder
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNix = file: file.hasExt "nix" && !lib.hasPrefix "_" file.name;
    importTree = path: toList (fileFilter isNix path);
    mkFlake = inputs.flake-parts.lib.mkFlake { inherit inputs; };
  in mkFlake { imports = importTree ./nix; };
}

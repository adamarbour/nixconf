{
  flake.wrappers.my-nvim = { pkgs, wlib, ... }: {
    imports = [
      wlib.wrapperModules.neovim
    ];

    package = pkgs.neovim-unwrapped;

    runtimePkgs = with pkgs; [
      nixd
      nixfmt
      ripgrep
      fd
      git
    ];

    settings = {
      config_directory = ./neovim;
    };
  };
}

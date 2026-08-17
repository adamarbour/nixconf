{
  flake.wrappers.git = { wlib, lib, pkgs, ... }: {
    imports = [wlib.modules.default];

    package = pkgs.git;
    runtimePkgs = with pkgs; [ git-lfs delta openssh gnupg ];


    env = {
      GIT_AUTHOR_NAME = "Adam";
      GIT_AUTHOR_EMAIL = "845679+adamarbour@users.noreply.github.com";
      GIT_COMMITTER_NAME = "Adam";
      GIT_COMMITTER_EMAIL = "845679+adamarbour@users.noreply.github.com";
    };
  };
}

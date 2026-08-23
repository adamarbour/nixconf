{
  flake.wrappers.my-git = { pkgs, wlib, ... }: {
    imports = [
      wlib.wrapperModules.git
    ];

    package = pkgs.git;

    runtimePkgs = [
      pkgs.delta
    ];

    settings = {
      init = {
        defaultBranch = "main";
      };
      fetch = {
        prune = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      rerere = {
        enabled = true;
      };
      commit = {
        verbose = true;
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      alias = {
        st = "status --short --branch";
        lg = "log --graph --decorate --oneline --all";
        last = "log -1 HEAD --stat";
        amend = "commit --amend --no-edit";
        unstage = "restore --staged";
      };
    };
  };
}

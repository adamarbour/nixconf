{ config, ... }:
{
  flake.wrappers.ghostty =
    {
      wlib,
      lib,
      ...
    }:
    {
      imports = [
        wlib.wrapperModules.ghostty
      ];

      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = lib.mkDefault 11; # per-host override target
        font-feature = [
          "-liga"
          "-dlig"
          "-calt"
        ];

        cursor-style = "block";
        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        window-padding-x = 8;
        window-padding-y = 8;
        window-decoration = true;
        confirm-close-surface = false;

        scrollback-limit = 100000;

        clipboard-read = "allow";
        clipboard-write = "allow";
        copy-on-select = "clipboard";

        theme = "catppuccin-frappe";

        keybind = [
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+t=new_tab"
          "ctrl+shift+w=close_surface"
          "ctrl+shift+enter=toggle_fullscreen"
          "ctrl+shift+comma=reload_config"
        ];
      };
    };

  flake.modules.nixos.ghostty = config.flake.wrappers.ghostty.install;
}

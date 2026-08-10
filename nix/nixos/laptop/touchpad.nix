{ inputs, self, ... }:
{
  flake.modules.nixos.laptop = { lib, config, ... }: {

    services.libinput = {
      enable = true;

      # disable mouse acceleration
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };

      # touchpad settings
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
      };
    };

    # trackpad for lenovo
    hardware.trackpoint.enable = lib.mkDefault true;
    hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

  };
}

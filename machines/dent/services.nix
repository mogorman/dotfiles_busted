{ config, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
in
{
  services.blueman.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #services.xserver.multitouch.enable = true;
  services.xserver.wacom.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.modules = [ pkgs.xf86_input_wacom ];
  environment.variables = { MOZ_USE_XINPUT2="1";
                           # XLIB_SKIP_ARGB_VISUALS="1";
                          };

  services.xserver.layout = "us";
  services.printing.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
}

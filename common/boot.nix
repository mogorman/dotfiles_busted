{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config= baseconfig; };
in
{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #    services.throttled.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;

  services.logind.lidSwitch = "lock";
  services.logind.lidSwitchDocked = "lock";

  services.fstrim.enable = true;
  services.fstrim.interval = "daily";
  boot.tmpOnTmpfs = true;

  boot.cleanTmpDir = true;
}

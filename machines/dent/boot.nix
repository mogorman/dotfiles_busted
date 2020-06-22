{ config, lib, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config= baseconfig; };
in
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;

  boot.initrd.luks.gpgSupport = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/086251b4-7d51-4873-b4f6-0aa3ae7088ce";
      preLVM = true;
      allowDiscards = true;
      gpgCard = {
        gracePeriod = 25;
        encryptedPass = "${/etc/nixos/boot/pass/pass.gpg}";
        publicKey = "${/etc/nixos/boot/pub/mog.asc}";
      };
    };
  };

  boot.kernelModules = [ "kvm-intel" ];

  boot.extraModprobeConfig = ''
  options psmouse proto=imps
  '';

  services.udev = {
    path = [ pkgs.xorg.setxkbmap pkgs.xorg.xinput ];
    extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="34:13:e8:37:5c:fd", NAME="wlan0"
        SUBSYSTEM=="input", ATTRS{name}=="8Bitdo SF30 Pro", MODE="0666", ENV{ID_INPUT_JOYSTICK}="1"

        ATTR{idVendor}=="1d50", ATTR{idProduct}=="60e6", SYMLINK+="greatfet-one-%k", MODE="660", GROUP="dialout"
        ATTR{idVendor}=="1fc9", ATTR{idProduct}=="000c", SYMLINK+="nxp-dfu-%k", MODE="660", GROUP="dialout"

        SUBSYSTEM=="usb", ATTR{idVendor}=="04b4", ATTR{idProduct}=="8613", SYMLINK+="stream-%k", TAG+="uaccess", MODE="660", GROUP="dialout"
        SUBSYSTEM=="usb", ATTR{idVendor}=="04b4", ATTR{idProduct}=="00f1", SYMLINK+="stream-%k", TAG+="uaccess", MODE="660", GROUP="dialout"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="601f", SYMLINK+="stream-%k", TAG+="uaccess", MODE="660", GROUP="dialout"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6108", SYMLINK+="stream-%k", TAG+="uaccess", MODE="660", GROUP="dialout"
        SUBSYSTEM=="xillybus", MODE="666", OPTIONS="last_rule"


# Rule for USB Receiver
SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c53e", MODE="0660", TAG+="uaccess", GROUP="dialout"

# Rule when connected via Bluetooth
# Updated rule, thanks to Torsten Maehne (https://github.com/maehne)
SUBSYSTEMS=="input", ATTRS{name}=="SPOTLIGHT*", MODE="0660", TAG+="uaccess", GROUP="dialout"

#        ATTR{idVendor}=="0658", ATTR{idProduct}=="0200", SYMLINK+="zwave", MODE="666", GROUP="dialout", TAG+="uaccess"
#        ATTR{idVendor}=="1cf1", ATTR{idProduct}=="0030", SYMLINK+="zigbee", MODE="666", GROUP="dialout", TAG+="uaccess"

      '';
    };

  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    USB_BLACKLIST="1d50:60e6 20a0:4108"
  '';
}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./secrets.nix
      ../../common.nix
    ];


  # https://bugzilla.kernel.org/show_bug.cgi?id=110941
  boot.kernelParams = [ "intel_pstate=no_hwp" "acpi_call"];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Grub menu is painted really slowly on HiDPI, so we lower the
  # resolution. Unfortunately, scaling to 1280x720 (keeping aspect
  # ratio) doesn't seem to work, so we just pick another low one.
  boot.loader.grub.gfxmodeEfi = "1024x768";

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/4ae54e6e-4224-4dd2-9861-ac7b824b5f76";
      preLVM = true;
      allowDiscards = true;
    }
  ];


  # Use the GRUB 2 boot loader.
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
#  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_4_19;
#  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "ford"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.stumpwm.enable = true;
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true
  programs.ssh.startAgent = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.extraUsers.mog = {
     isNormalUser = true;
    createHome = true;
    group = "users";
    extraGroups = [ "networkmanager" "wheel" "dialout" "vboxusers" "docker" "libvirtd" "nitrokey" ];
     uid = 1000;
   };


  networking.extraHosts = "
  127.0.0.1 ford localhost my.appcues.dev fast.appcues.dev api.appcues.dev auth.appcues.com
  ";
### from hardware
#  boot.blacklistedKernelModules = [ "i915" ];
hardware.bumblebee.enable = true;

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
];

  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  systemd.services.cpu-throttling = {
    enable = true;
    description = "Sets the offset to 3 °C, so the new trip point is 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    path = [ pkgs.msr-tools ];
    script = "wrmsr -a 0x1a2 0x3000000";
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [
      "timers.target"
    ];
  };

  systemd.timers.cpu-throttling = {
    enable = true;
    description = "Set cpu heating limit to 97 °C";
    documentation = [
      "https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Power_management.2FThrottling_issues"
    ];
    timerConfig = {
      OnActiveSec = 60;
      OnUnitActiveSec = 60;
      Unit = "cpu-throttling.service";
    };
    wantedBy = [
      "timers.target"
    ];
};



hardware.opengl.driSupport32Bit = true;

hardware.pulseaudio.package = pkgs.pulseaudioFull;
hardware.bluetooth.enable = true;
networking.dnsExtensionMechanism = false;
services.autorandr.enable = true;

  services.udev = {
      path = [ pkgs.xorg.setxkbmap pkgs.xorg.xinput ];
      extraRules = ''
        SUBSYSTEM=="usb", ACTION=="add", ATTR{idVendor}=="f617", ATTR{idProduct}=="0905", RUN+="${pkgs.bash}/bin/bash /home/mog/.bin/udevfixkb ${pkgs.xorg.setxkbmap}/bin/setxkbmap", OWNER="mog"
        ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="54:e1:ad:f9:cd:c5", NAME="eth0"
        ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="00:e0:4c:a4:e9:cd", NAME="eth1"
        ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="18:1d:ea:00:a6:4a", NAME="wlan0"
SUBSYSTEM=="input", ATTRS{name}=="8Bitdo SF30 Pro", MODE="0666", ENV{ID_INPUT_JOYSTICK}="1"
      '';
  };
services.logind.lidSwitch = "ignore";

virtualisation.virtualbox.host.enable = true;
virtualisation.virtualbox.host.enableExtensionPack = true;
###

services.fstrim.enable = true;

services.nscd.config = ''
  server-user             nscd
  threads                 1
  paranoia                no
  debug-level             0
  
  enable-cache            passwd          yes
  positive-time-to-live   passwd          600
  negative-time-to-live   passwd          20
  suggested-size          passwd          211
  check-files             passwd          yes
  persistent              passwd          no
  shared                  passwd          yes
  
  enable-cache            group           yes
  positive-time-to-live   group           3600
  negative-time-to-live   group           60
  suggested-size          group           211
  check-files             group           yes
  persistent              group           no
  shared                  group           yes
  
  enable-cache            hosts           yes
  positive-time-to-live   hosts           600
  negative-time-to-live   hosts           0
  suggested-size          hosts           211
  check-files             hosts           yes
  persistent              hosts           no
  shared                  hosts           yes
'';
zramSwap.enable = true;
zramSwap.memoryPercent = 100;
zramSwap.numDevices = 1;
boot.tmpOnTmpfs = true;
#android_sdk.accept_license = true;

environment.etc."nixos/active".text = config.system.nixos.label;

services.undervolt = {
  enable = true;
  coreOffset = "-85";
#  temp = "97";
  gpuOffset = "0";
  uncoreOffset = "-85";
  analogioOffset = "0";
};

boot.plymouth.enable = true;
boot.plymouth.logo = 
  pkgs.fetchurl {
#            url = "https://nixos.org/logo/nixos-hires.png";
#            sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
            url = "https://user-images.githubusercontent.com/64710/45883713-db260b80-bd7f-11e8-96ab-a1bdcbb4ffa9.png";
            sha256 = "1kcihsd1wbmdxqmqfw8cf1vnb9pzaqqx0p9afa9nz0saymp6fnjp";
          }
;

#services.osquery.enable = true;
#services.undervolt = { enable = true; coreOffset = "-100"; temp = "97"; };
#  services.undervolt = {
#    enable = true;
#    tempAc = 97;
#    tempBat = 75;
#    coreOffset = -120;
###    cache = -120;
#    gpuOffset = -55;
#    uncoreOffset = -70;
#    analogioOffset = -70;
#};
services.xserver.desktopManager.xfce.enableXfwm = false;
services.xserver.desktopManager.xfce.noDesktop = true;
services.xserver.desktopManager.xfce.thunarPlugins = [ pkgs.xfce.thunar-archive-plugin  ];
services.xserver.desktopManager.xfce.extraSessionCommands = ''
stumpwm
'';
services.keybase.enable = true;

nix.binaryCaches = [
  "https://cache.nixos.org/"

  # This assumes that you use the default `nix-serve` port of 5000
  "https://nix.rldn.net/"
];

nix.binaryCachePublicKeys = [
  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

  # Replace the following string with the contents of the
  # `nix-serve.pub` file you generated in the "Server configuration"
  # section above
  "nix.rldn.net-1:41SDd7l+A6qqpUPC8Tu43ThJucFQG+WdrwJtHFF0MZM="
];

}

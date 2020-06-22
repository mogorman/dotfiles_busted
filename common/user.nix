{ config, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
in
{
  users.extraUsers.mog = {
    isNormalUser = true;
    createHome = true;
    group = "users";
    extraGroups = [ "networkmanager" "wheel" "dialout" "vboxusers" "docker" "libvirtd" "nitrokey" "plugdev" ];
    uid = 1000;
  };
}

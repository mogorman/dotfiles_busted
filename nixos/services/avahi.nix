{ config, lib, pkgs, ... }:
{
  services.avahi = {
    enable = true;
    interfaces = [ "br0" ];
    nssmdns = true;

    publish = {
      enable = true;
      userServices = true;
    };
  };
}

{ config, lib, pkgs, ... }:
{
  services.unifi.enable = true;
  services.unifi.openPorts = false;
  systemd.services.unifi.wantedBy =  lib.mkForce [];
}

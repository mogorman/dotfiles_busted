{ config, lib, pkgs, ... }:
{
  services.dnsmasq = {
    enable = true;
    servers = [ "8.8.8.8" "8.8.4.4" ];
    extraConfig = ''
      domain=lan
      interface=br0
      bind-interfaces
      no-negcache
      dhcp-range=192.168.3.10,192.168.3.254,24h
    '';
  };
}

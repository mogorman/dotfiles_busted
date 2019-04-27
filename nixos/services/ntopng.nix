{ config, lib, pkgs, ... }:
{
  services.geoip-updater.enable = false;
  services.ntopng.enable = true;
  services.ntopng.http-port = 3000;
  services.ntopng.configText = ''
    --http-prefix=/network
    --data-dir=/internal500/packet_logs
    --pid-path=/internal500/packet_logs/ntopng.pid
  '';
}

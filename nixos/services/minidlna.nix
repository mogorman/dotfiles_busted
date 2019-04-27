{ config, lib, pkgs, ... }:
{
  services.minidlna.enable = true;
  services.minidlna.mediaDirs = [
    "/external_drive/samba_share"
  ];
}

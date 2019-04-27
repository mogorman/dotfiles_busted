{ config, lib, pkgs, ... }:
{
 # unstable.minecraft-server
  services.minecraft-server = {
    enable = false;
    dataDir = "/external_drive/minecraft";
    openFirewall = false;
  };
}

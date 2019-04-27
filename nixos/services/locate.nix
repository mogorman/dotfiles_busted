{ config, lib, pkgs, ... }:
{
  services.locate.enable = true;
  services.locate.localuser = "root";
}

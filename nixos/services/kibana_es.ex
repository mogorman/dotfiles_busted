{ config, lib, pkgs, ... }:
{
  services.kibana.enable = true;
  services.elasticsearch.enable = true;
}

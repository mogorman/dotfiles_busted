{ config, lib, pkgs, ... }:
{
  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1";
    secretKeyFile = "/etc/nixos/nix-serve.sec";
  };
}

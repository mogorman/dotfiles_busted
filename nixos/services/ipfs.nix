{ config, lib, pkgs, ... }:
{
#  services.ipfs.enable=true;
#  services.ipfs.emptyRepo = true;
#  services.ipfs.enableGC = true;
##  services.ipfs.user = "root";
##  services.ipfs.group = "users";
#  services.ipfs.extraFlags = [
##    "--mount"
#    "--mount-ipfs=/var/lib/ipfs/ipfs"
#    "--mount-ipns=/var/lib/ipfs/ipns"
#  ];
##  services.ipfs.apiAddress = "/ip4/172.16.50.1/tcp/5001";
#  systemd.services.ipfs.path =  lib.mkForce [ pkgs.ipfs pkgs.fuse ];
}

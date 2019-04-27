{ config, lib, pkgs, ... }:
{
  services.firefox.syncserver.enable = true;
  services.firefox.syncserver.allowNewUsers = true;
  services.firefox.syncserver.publicUrl = "https://sync.rldn.net/";

#  systemd.services.syncserver.path = [ pkgs.unstable.pythonPackages.syncserver pkgs.unstable.pythonPackages.pasteScript pkgs.unstable.coreutils ]; 
#  systemd.services.syncserver.environment.PYTHONPATH = "${pkgs.unstable.pythonPackages.syncserver}/lib/${pkgs.unstable.pythonPackages.python.libPrefix}/site-packages";
#  systemd.services.syncserver.serviceConfig.ExecStart = lib.mkForce "${pkgs.unstable.pythonPackages.pasteScript}/bin/paster serve ${syncServerIni}";

#  test = pkgs.unstable.python.withPackages(ps: with ps; [ syncserver pasteScript ]);
#  systemd.services.syncserver.path = lib.mkForce [ pkgs.unstable.coreutils test ];
  
#  systemd.services.syncserver.path = lib.mkForce { let
#    overSyncServerEnv = pkgs.unstable.python.withPackages(ps: with ps; [ syncserver pasteScript ]);
#  in
#    [ pkgs.unstable.coreutils overSyncServerEnv ];
#  };
# lib.mkForce [pkgs.unstable.coreutils pkgs.unstable.python.withPackages(ps: with ps; [ syncserver pasteScript ])];
#  systemd.services.ipfs.path =  lib.mkForce [ pkgs.ipfs pkgs.fuse ];
}

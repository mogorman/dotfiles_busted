{ config, lib, pkgs, ... }:
{
  services.sslh = {
    enable = true;
    listenAddress = "0.0.0.0";
# { name: "ssh"; service: "ssh"; host: "localhost"; port: "22"; probe: "builtin"; },
# { name: "openvpn"; host: "localhost"; port: "1194"; probe: "builtin"; },
# { name: "xmpp"; host: "localhost"; port: "5222"; probe: "builtin"; },
# { name: "http"; host: "localhost"; port: "80"; probe: "builtin"; },

    appendConfig = ''
    protocols: ( { name: "ssh"; service: "ssh"; host: "localhost"; port: "22"; probe: "builtin"; },
                 { name: "openvpn"; service: "openvpn";  host: "localhost"; port: "1194"; probe: "builtin"; },
                 { name: "xmpp";  service: "xmpp"; host: "localhost"; port: "5222"; probe: "builtin"; },
                 { name: "http";  service: "http"; host: "localhost"; port: "80"; probe: "builtin"; },
                 { name: "ssl";  service: "ssl"; host: "localhost"; port: "444"; probe: "builtin"; }, 
                 { name: "tinc";  service: "tinc"; host: "localhost"; port: "655"; probe: "builtin"; },
                 { name: "anyprot"; host: "localhost"; port: "655"; probe: "builtin"; }
   );
   '';
  };
}

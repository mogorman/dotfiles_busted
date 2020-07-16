{ config, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
in
{
  services.blueman.enable = true;
  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  networking.firewall.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #services.xserver.multitouch.enable = true;
  services.xserver.wacom.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.modules = [ pkgs.xf86_input_wacom ];
  environment.variables = { MOZ_USE_XINPUT2="1";
                           # XLIB_SKIP_ARGB_VISUALS="1";
                          };

  services.xserver.layout = "us";
  services.printing.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;


  # Enable Wireguard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "192.168.255.5/24" ];

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/nixos/machines/dent/wireguard-private";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "U++AMnQZh5xnD2GL5ORgj1DTsu7CYvdy4akUMvD4yj8=";

          # Forward all the traffic via VPN.
          allowedIPs = [ "192.168.255.0/24" ];
          # Set this to the server IP and port.
          endpoint = "home.rldn.net:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

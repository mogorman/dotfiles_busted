# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./services.nix
      ./hardware-configuration.nix
      ./boot.nix
      ./packages.nix

      ./../../common/boot.nix
      ./../../common/common.nix
      ./../../common/user.nixos
    ];

  networking.hostName = "dent"; # Define your hostname.
  networking.extraHosts = "
                          127.0.0.1 dent localhost
  ";
  networking.networkmanager.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.0.2u"
  ];

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

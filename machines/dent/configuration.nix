# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config = baseconfig; };
in {
  imports = [ # Include the results of the hardware scan.
    ./services.nix
    ./hardware-configuration.nix
    ./boot.nix
    ./packages.nix

    ./../../common/boot.nix
    ./../../common/common.nix
  ];

  networking.hostName = "dent"; # Define your hostname.

  networking.networkmanager.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.0.2u" ];

}

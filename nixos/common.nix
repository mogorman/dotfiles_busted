{ config, lib, pkgs, ... }:
let
  unstable = import <unstable> { config.allowUnfree = true; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      # ./users.nix
      # ./packages.nix
      # ./common_boot.nix
      # ./common_networking.nix
      # ./common_services.nix
    ];

  system.stateVersion = "18.09";

  system.autoUpgrade.enable = true;

  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    consoleFont = "Lat2-Terminus16";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      terminus_font
      unifont # some international languages
    ];
  };

  time.timeZone = "US/Eastern";
  
  programs.bash.enableCompletion = true;
  
hardware.nitrokey.enable = true;
security.pam.enableSSHAgentAuth = true;


nixpkgs.config = {
  pulseaudio = true;
  allowUnfree = true;

  packageOverrides = super: let self = super.pkgs; in {
    xfce = super.xfce // {
      gvfs = pkgs.gvfs;
    };
    steam = super.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        nettools       # for `hostname`, which some scripts expect
        bumblebee      # for optirun
      ];
    };
    mplayer = super.mplayer.override {
      pulseSupport = true;
    };
#    linuxPackages = super.linuxPackages_latest.extend (self: super: {
#      nvidiaPackages = super.nvidiaPackages // {
#        stable = unstable.linuxPackages_latest.nvidiaPackages.stable_418;
#      };
#    });
  };
};

}

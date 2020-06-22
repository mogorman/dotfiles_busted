{ config, lib, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
    passff-host = pkgs.callPackage ../programs/passff.nix {};
in
{
    imports =
      [
        ./fonts.nix
      ];

  system.stateVersion = "19.09"; # Did you read the comment?

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  security.pam.enableSSHAgentAuth = true;

  environment.etc."nixos/active".text = config.system.nixos.label;
  environment.etc."nixos/current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in formatted;
  environment.etc."vim/vimrc".text = ''
    set nocompatible
    syntax on
    set backspace=indent,eol,start
  '';

  programs.mosh.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.lorri.enable = true;

  #  system.autoUpgrade.enable = true;

  time.timeZone = "US/Eastern";

  programs.bash.enableCompletion = true;

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;

    packageOverrides = super: let self = super.pkgs; in {
      pidgin-with-plugins = super.pidgin-with-plugins.override {
        ## Add whatever plugins are desired (see nixos.org package listing).
        plugins = [ pkgs.purple-facebook ];
      };
      steam = super.steam.override {
        extraPkgs = p: with p; [
          glxinfo        # for diagnostics
          nettools       # for `hostname`, which some scripts expect
        ];
      };
      mplayer = super.mplayer.override {
        pulseSupport = true;
      };
    };
  };

}

{ config, lib, pkgs, ... }:

let
  unstable = import <unstable> {};
  oldstable = import <oldstable> {};
in
{

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "b6e5a5f5b4aac16072e3761018e4185f1067bb0e";
    }))
  ];
  environment.systemPackages = with pkgs; [
    #system
    usbutils
    pciutils
    #  openssl
    vim
    wget
    screen
    nmap
    tinc
    bash
    shared_mime_info
    aspell
    aspellDicts.en
    zip
    unzip
    psmisc
    psutils
    fortune
    rsync
    iftop
    curl
    netcat-openbsd
    moreutils
    acpi
    tinc_pre
    tor
    torsocks
    tsocks
    pmutils
    whois
    nss
    atop
    awscli
    unrar
    bash-completion
    bashSnippets
    bind
    inotify-tools
    powertop
    p7zip
    pssh

    #user
    ack
    docker
    packer
    gitAndTools.gitFull
    gitAndTools.git-crypt
    lsof
    youtube-dl
    platformio
    openocd
    esptool
    ffmpeg
    nix-index
    python
    bc
    gnupg
    pinentry
#  pinentry_ncurses
    pinentry_gnome
    jq
    flatpak
    direnv
    ispell
    imagemagick
    plantuml
    xdotool
    ditaa
    graphviz
    htop
    nix-top
    home-manager
    gmrun
    hstr
    aescrypt
    tldr
    tlp
    xorg.xhost
    pscircle
    patchelf
    ntp
    hugo
    mosh
    nixfmt
    #user gui
    vlc
    emacsGit
    smplayer
    mplayer
    pavucontrol
    wireshark
    pgadmin
    evince
    gtkspell3
    hexchat
    libreoffice
    gnumeric
    zoom-us
    xdg_utils
    xorg.xkill
    baobab
    gimp
    gksu
    signal-desktop
    steam
    steam-run
    wine
    qemu
    qcachegrind
    syncthing
    qsyncthingtray
    oldstable.mcomix
    nitrokey-app
    gpa
    gparted
    apg
    connect
    kcachegrind
    libnotify
    avahi

    # gnuradio-with-packages
    # unstable.gnuradio-limesdr
    # unstable.soapysdr-with-plugins
    # unstable.limesuite
    # unstable.gnuradio-osmosdr
    audacity
    firefox
    firefox-devedition-bin
    slack
    google-chrome
    #  empathy
    # keybase-gui
    #  chrome-gnome-shell
    #  gnomeExtensions.gsconnect
    #  gnome3.zenity
    #  gnome3.polari
    #  gnome-podcasts
    #  gnome3.gnome-tweaks
    #  gnome3.gnome-power-manager
    #  gnome3.eog
    #  gnome3.vinagre
    #  gnome3.cheese
    #  gnome3.pomodoro
    #  gnome3.gnome-boxes
    unstable.tilix
    quicksynergy

    etherape
    yarn
    #  xdg-desktop-portal
    #  xdg-desktop-portal-gtk
    #  pipewire
    gqrx
    curaLulzbot
    #  evtest
    #  wl-clipboard
    #  libinput
    xorg.xeyes
    #  wev
    thefuck
    vscode
    trash-cli
    pidgin-with-plugins
    unstable.insomnia
    pass-otp
  ];

  programs.bash.enableCompletion = true;
  environment.profileRelativeEnvVars = {
    GRC_BLOCKS_PATH = [ "/share/gnuradio/grc/blocks" ];
  };

}

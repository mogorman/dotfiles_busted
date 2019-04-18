{ config, lib, pkgs, ... }:
{

programs.firejail = {
  enable = true;
  wrappedBinaries = {
    firefox = "${lib.getBin pkgs.firefox}/bin/firefox";
    google-chrome = "${lib.getBin pkgs.google-chrome}/bin/google-chrome";
#    spotify = "${lib.getBin pkgs.spotify}/bin/spotify";
    slack = "${lib.getBin pkgs.slack}/bin/slack";
  };
};

environment.systemPackages = with pkgs; [
  spotify  # figure out jail and fix
  vim
  wget
  usbutils
  pciutils
  blueman
  ack
  vlc
  emacs
  smplayer
  mplayer
  pavucontrol
  paprefs
  screen
  packer
  openssl
  mysql
  gitAndTools.gitFull
  gitAndTools.git-crypt
  lsof
  xorg.xev
  pianobar
  wireshark
  nmap
  hexchat
  xscreensaver
  gnome3.eog
  tinc
  bash
  terminus_font
  terminus_font_ttf
  pgadmin
  evince
  shared_mime_info
  aspell
  aspellDicts.en
  gtkspell3
  gtk2fontsel
  xfontsel
  xvfb_run
  zip
  unzip
  psmisc
  corefonts
  fortune
  rsync
  screen
  ack
  iftop
  curl
  youtube-dl
  arandr
  pasystray
  netcat-openbsd
  libreoffice
  gnumeric
  elixir
  erlang
  docker
  packer
  pa_applet
  moreutils
  wine
  platformio
  openocd
  acpi
  tinc_pre
  torsocks
  tsocks
  x11vnc
  scrot
  pmutils
  audacity
  gtk_engines
  clearlooks-phenix
  xfce.gtk-xfce-engine
  xorg.xmodmap
  lxappearance
  #androidsdk
  whois
  nss
  zoom-us
  unrar
  gnome3.vinagre
  xdg_utils
  xorg.xkill
  aescrypt
  arduino
  baobab
  bash-completion
  bashSnippets
  bind
  esptool
  ffmpeg
  gimp
  gksu
  gpodder
  gsettings-desktop-schemas
  inotify-tools
  inkscape
  nix-index
  pcb
  geda
  powertop
  psutils
  signal-desktop
 steam
 steam-run
  wine
  transmission-gtk
#  xpra
  mysql-workbench
  python
  bc
  gnupg
  pinentry
  pinentry_ncurses
  gnuradio-with-packages
  networkmanagerapplet
  roxterm
  dolphinEmu
  p7zip
  gnome3.cheese
  vagrant
  jq
  baobab
  flatpak
  direnv
  sshuttle
  gmrun
  qemu
  hstr
  qcachegrind
  gnome3.zenity
  synergy
  syncthing
  qsyncthingtray
  mcomix
  ispell
  imagemagick
  plantuml
  xdotool
  ditaa
  graphviz
  htop
  nix-top
  home-manager
  nitrokey-app
  tldr
  gpa
  gparted
  (lib.overrideDerivation lispPackages.stumpwm (x: {
    linkedSystems = x.linkedSystems ++ ["clx-truetype" "xkeyboard" "xembed" ];
    buildInputs = x.buildInputs ++ (with lispPackages; [clx-truetype xkeyboard xembed ]);
  }))
];

programs.bash.enableCompletion = true;
environment.profileRelativeEnvVars = {
  GRC_BLOCKS_PATH = [ "/share/gnuradio/grc/blocks" ];
};

environment.etc."vim/vimrc".text = ''
set nocompatible
syntax on
set backspace=indent,eol,start
'';
}


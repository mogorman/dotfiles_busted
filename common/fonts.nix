{ config, pkgs, ... }:
let
    baseconfig = { allowUnfree = true;};
    unstable = import <unstable> { config= baseconfig;};
in
{
  console.keyMap = "us";
  console.font = "Lat2-Terminus16";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      corefonts
      mononoki
      victor-mono
      ankacoder
      ankacoder-condensed
      terminus_font
      terminus_font_ttf
    ];
  };
}

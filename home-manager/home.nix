{ pkgs, ... }:
{
  home.file.".stumpwm.d".source = "/home/mog/code/dotfiles/home-manager/stumpwm";
  services.dunst.enable = true;
  services.dunst.settings = {
  global = {
    geometry = "400x5-30+50";
    transparency = 10;
    frame_color = "#eceff1";
    font = "Terminus 10";
  };
  };
}

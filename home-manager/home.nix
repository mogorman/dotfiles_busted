{ pkgs, ... }:
{
  home.file.".stumpwm.d".source = "/home/mog/code/dotfiles/home-manager/stumpwm";
  services.dunst.enable = true;
  
  services.dunst.settings = {
    global = {
      geometry = "0x0-0+20";
      transparency = 10;
      frame_color = "#FF3B4E";
      format = "<b>%a</b>:%n %s %b";
      font = "Terminus 14";
      icon_position = "left";
      max_icon_size = "32";
    };
    urgency_normal = {
      background = "#5C5CFF";
      foreground = "#eceff1";
      timeout = 10;
    };
    urgency_low = {
      background = "#8AD5FF";
      foreground = "#eceff1";
      timeout = 10;
    };
    urgency_critical = {
      background = "#FF3B4E";
      foreground = "#eceff1";
      timeout = 10;
    };
  };
}

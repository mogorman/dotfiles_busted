{ pkgs, ... }:
{
  services.blueman-applet.enable = true;
  services.network-manager-applet.enable = true;
  services.pasystray.enable = true;
  services.syncthing.tray = true;
  services.xscreensaver.enable = true;
  home.file.".xscreensaver".source = "/home/mog/code/dotfiles/home-manager/xscreensaver";

  xsession.enable = true;
  xsession.windowManager.command = "";
  xsession.initExtra = ''
    source ~/.bashrc
    fixkb
    autorandr &
    stumpwm &
    sleep 4
    startxfce4
  '';
  home.file.".stumpwm.d".source = "/home/mog/code/dotfiles/home-manager/stumpwm";
  programs.autorandr.enable = true;
  programs.autorandr.hooks.postswitch = {
    "fix_screen" = "${pkgs.stumpish}/bin/stumpish refresh-heads";
    "fix_kb" = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -option \"ctrl:nocaps\"";
  };
  programs.autorandr.profiles = {
    "mobile" = {
      fingerprint = {
        eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
      };
      config = {
        DP-1.enable = false;
        DP-2.enable = false;
        HDMI-1.enable = false;
        HDMI-2.enable = false;
        eDP-1 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "2560x1440";
          rate = "60.00";
        };
      };
    };
    "work" = {
      fingerprint = {
        eDP-1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        DP-2 = "00ffffffffffff0006b3a227010101012e1b0104b53c2278ff2891a7554ea3260f5054bfef80714f81c08100814081809500b300d1c04dd000a0f0703e803020350055502100001a000000fd00283c87873c010a202020202020000000fc004d58323755430a202020202020000000ff0048424c4d52533032313038350a01ba02031bf14e010203040510111213141f2021222309070783010000276800a0f0703e803020350055502100001a565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e662156aa51001e30468f330055502100001e0e1f008051001e304080370055502100001c0000000000000000000002";
      };
      config = {
        eDP-1.enable = false;
        DP-2 = {
          enable = true;
          primary = true;
          position = "0x0";
          mode = "3840x2160";
          rate = "60.00";
        };
      };
    };
  };
  services.dunst.enable = true;
  services.dunst.settings = {
    # shortcuts = {
    #   close = "mod4+u";
    #   close_all = "mod4+i";
    #   history = "mod4+o";
    # };
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

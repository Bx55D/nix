{ config, pkgs, lib, ... }:
let
dwm-local-src = lib.cleanSource /home/bud/.applications/dwm;
  dwm-local = pkgs.dwm.overrideAttrs (oldAttrs: {
    src = dwm-local-src;
    patches = []; # Add patches here if you have any
  });
in
{
  services.xserver = {
    enable = true;
    windowManager.dwm = {
      enable = true;
      package = dwm-local;
    };
    # Configure keymap in X11
    xkb = {
      layout = "gb";
      variant = "";
    };
  };

  # Slock is an X11 screen locker
  programs.slock.enable = true;
}

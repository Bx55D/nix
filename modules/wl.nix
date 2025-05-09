{ config, pkgs, lib, ... }:
let
dwm-local-src = lib.cleanSource /home/bud/.applications/dwm;
  dwm-local = pkgs.dwm.overrideAttrs (oldAttrs: {
    src = dwm-local-src;
    patches = []; # Add patches here if you have any
  });

dwl-local-src = lib.cleanSource /home/bud/.applications/dwl;
  dwl-local = pkgs.dwl.overrideAttrs (oldAttrs: {
    src = dwl-local-src;
    patches = []; # Add patches here if you have any
  });

dwlb-local-src = lib.cleanSource /home/bud/.applications/dwlb;
  dwlb-local = pkgs.dwlb.overrideAttrs (oldAttrs: {
    src = dwlb-local-src;
    patches = []; # Add patches here if you have any
  });


in
{
	environment.systemPackages = with pkgs; [
		swaybg
		wbg
		wmenu
		wl-clipboard
		wl-clipboard-x11
		wlroots_0_18
		dwlb-local
		dwl-local
	];
  hardware.graphics.enable = true;
  services.pipewire = {
  	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
  };
  services.xserver = {
    enable = false;
	xkb = {
		layout = "gb";
	};
  };

  # Slock is an X11 screen locker
  programs.slock.enable = false;
}

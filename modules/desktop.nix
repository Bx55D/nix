# modules/packages/profiles/desktop.nix
{ pkgs, config, lib, ... }:
let
st-local-src = lib.cleanSource /home/bud/.applications/st;
st-local = pkgs.st.overrideAttrs (oldAttrs: {
		src = st-local-src;
		patches = [];
		});
in
{
	# Wayland Support By Default
	imports = [
		./wl.nix
	];
	environment.systemPackages = with pkgs; [
	  firefox
	  nautilus
	  feh
	  pipewire
	  wireplumber
	  catppuccin-gtk
	  remmina
	  refine
	  brightnessctl
	  st-local
	];
}

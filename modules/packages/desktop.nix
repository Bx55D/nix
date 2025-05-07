# modules/packages/profiles/desktop.nix
{ pkgs, config, lib, ... }:
let
dwmblocks-local-src = lib.cleanSource /home/bud/.applications/dwmblocks;
dwmblocks-local = pkgs.dwmblocks.overrideAttrs (oldAttrs: {
		src = dwmblocks-local-src;
		patches = [];
		});

st-local-src = lib.cleanSource /home/bud/.applications/st;
st-local = pkgs.st.overrideAttrs (oldAttrs: {
		src = st-local-src;
		patches = [];
		});
in
{
	environment.systemPackages = with pkgs; [
	  # Xorg base (could be a separate set if you want more granularity)
	  xorg.xev
	  xorg.xinit

	  # Desktop GUI Apps
	  firefox
	  nautilus
	  feh
	  pavucontrol
	  catppuccin-gtk
	  remmina
	  refine # Assuming this is a valid package name
	  brightnessctl
	  pulseaudio

	  # CLI tools relevant for a desktop
	  xclip
	  vim
	  neovim

	  # Suckless Suite (using the custom ones defined in configuration.nix)
	  st-local
	  dwmblocks-local
	  dmenu
	];
}

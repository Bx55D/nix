# modules/packages/common.nix
{ pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
	  git
	  linuxPackages.cpupower
	  unzip
	  neofetch
	  vim
	  neovim
	  xclip
	];
}

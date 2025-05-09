# modules/packages/common.nix
{ pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
	  gcc
	  clang-tools
	  git
	  linuxPackages.cpupower
	  unzip
	  fastfetch
	  vim
	  neovim
	  ripgrep
	];
}

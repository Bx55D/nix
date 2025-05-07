# modules/packages/common.nix
{ pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
	  gcc
	  gnumake
	  rustc
	  cargo
	  python314
	  nodejs_23
	];
}

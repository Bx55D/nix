# modules/packages/common.nix
{ pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
	  gnumake
	  rustc
	  cargo
	  python314
	  nodejs_23
	];
}

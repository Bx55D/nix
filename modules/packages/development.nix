# modules/packages/common.nix
{ pkgs, config, ... }:
{
	environment.systemPackages = with pkgs; [
	  clang-tools
	  gcc
	  gnumake
	  rustc
	  cargo
	  python314
	  nodejs_23
	];
}

{ config, pkgs, lib, ... }:

let
# --- Custom Local Package Definitions ---
# It's good practice to use lib.cleanSource to ensure only necessary files are included
# and to make the derivation reproducible.

# --- Home Manager Source ---
home-manager-src = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz;
in
{
	imports =
		[
		/etc/nixos/hardware-configuration.nix
			(import "${home-manager-src}/nixos") # Import HM NixOS module

			../../modules/base.nix
			../../modules/home-manager.nix
		];

	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"];
	nixpkgs.config.allowUnfree = true;

	# Fonts
	fonts.packages = with pkgs; [
	(nerdfonts.override { fonts = [ "Meslo" ]; })
		meslo-lg
	];

	# Zsh system-wide configuration (can also be moved to base.nix or a shell.nix)
	programs.zsh = {
		enable = true;
		enableBashCompletion = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		interactiveShellInit = ''
			source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
			bindkey '^[OA' history-search-backward
			bindkey '^[[A' history-search-backward
			bindkey '^[OB' history-search-forward
			bindkey '^[[B' history-search-forward
		  bindkey '^[[1;5D' backward-word
			bindkey '^[[1;5C' forward-word
		  '';
	};

}

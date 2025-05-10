{ config, pkgs, lib, ... }:

{
	imports =
		[
		../host.nix
		];

	environment.systemPackages = with pkgs; [
		vlock
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


	networking.networkmanager.enable = true;

	time.timeZone = "Europe/London";

	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_GB.UTF-8";
		LC_IDENTIFICATION = "en_GB.UTF-8";
		LC_MEASUREMENT = "en_GB.UTF-8";
		LC_MONETARY = "en_GB.UTF-8";
		LC_NAME = "en_GB.UTF-8";
		LC_NUMERIC = "en_GB.UTF-8";
		LC_PAPER = "en_GB.UTF-8";
		LC_TELEPHONE = "en_GB.UTF-8";
		LC_TIME = "en_GB.UTF-8";
	};

# Define a user account.
	users.users.bud = {
		isNormalUser = true;
		description = "Bud";
		extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.zsh; # zsh package will be installed if not already
	};

# Console keymap (distinct from X11 keymap)
	console.keyMap = "uk";
}

{ config, pkgs, lib, ... }:
{
	imports =
		[
			../common/configuration.nix
			../../modules/development-apps.nix
		];

# Bootloader.
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sda";
	boot.loader.grub.useOSProber = true;

	services.openssh.enable = true;

	system.stateVersion = "24.11";
}

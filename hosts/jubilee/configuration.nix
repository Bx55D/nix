{ config, pkgs, lib, ... }:
{
	imports =
		[
			../common/configuration.nix
			../../modules/desktop.nix
		];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelParams = [
		"intel_pstate=passive"
	];

# Pipewire
	services.pipewire.pulse.enable = true; # Enables pipewire-pulse

	programs.dconf.enable = true; # For GTK settings, etc.
	system.stateVersion = "24.11";
}

{ config, pkgs, lib, ... }:

{
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.bud = import /etc/nixos/home.nix;
}

{config, pkgs, ...}:
{
	home.username = "bud";
	home.homeDirectory = "/home/bud";
	home.stateVersion = "24.11";

	home.file = {
		".config/nvim" = {
		source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/nvim;
		};
	};

	programs.git = {
		enable = true;
		userName = "bud";
		userEmail = "ben.donovan@musiclegends.net";
	};
}

{config, pkgs, ...}:
{
	home.username = "bud";
	home.homeDirectory = "/home/bud";
	home.stateVersion = "24.11";

	programs.git = {
		enable = true;
		userName = "bud";
		userEmail = "ben.donovan@musiclegends.net";
	};
}

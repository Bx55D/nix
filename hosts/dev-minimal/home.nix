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

	home.file = {
		".zshrc" = {
			text = ''autoload -U colors && colors
			export PS1="%{$fg[blue]%}%n%{$reset_color%}@%m> "'';
		};
	};
}

{config, pkgs, ...}:
{
	home.username = "bud";
	home.homeDirectory = "/home/bud";

	programs.git = {
		enable = true;
		userName = "bud";
		userEmail = "ben.donovan@musiclegends.net";
	};

	home.file = {
		".zshrc" = {
			text = ''autoload -U colors && colors
			export PS1="%{$fg[blue]%}%n%{$reset_color%}@%m %1~ > "'';
		};

		".applications" = {
			source = config.lib.file.mkOutOfStoreSymlink "/home/bud/nix/dotfiles/applications";
		};
	};
}

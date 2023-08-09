{ pkgs, config, ... }:
{
	home = {
		packages = with pkgs; ([
			geany
		]);
		configFile = {
			"geany/geany.conf".source = "../../../../assets/geany/geany.conf";
			"geany/keybindings.conf".source = "../../../../assets/geany/keybindings.conf";
			"geany/colorschemes" = {
			 	recursive = true;
			    source = "../../../../assets/geany/colorschemes";
			};
		};
	};
}

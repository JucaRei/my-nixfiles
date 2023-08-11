{ pkgs, config, lib, ... }:
with lib.hm.gvariant;
{
	home = {
		packages = with pkgs; ([
			geany
		]);
		file = {
			"${config.xdg.configHome}/geany/geany.conf".text = builtins.readFile "../../../../assets/geany/geany.conf";
			"${config.xdg.configHome}/geany/keybindings.conf".text = builtins.readFile "../../../../assets/geany/keybindings.conf";
			# "${config.xdg.configHome}/geany/colorschemes" = {
			#  	recursive = true;
			#     source = "../../../../assets/geany/colorschemes";
			# };
		};
	};
}

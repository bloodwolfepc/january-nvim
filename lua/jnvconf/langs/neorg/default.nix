{ extraPkgs, pkgs, ... }:
{
  install = {
    startPlugins = {
      always = [
        extraPkgs.neorg
        pkgs.vimPlugins.neorg-interim-ls
      ];
    };
    startPlugins.forModule = {
      telescope = with pkgs.vimPlugins; [
        neorg-telescope
      ];
    };
  };
}

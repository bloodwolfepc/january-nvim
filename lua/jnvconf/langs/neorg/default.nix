{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        neorg
        neorg-interim-ls
        neorg-telescope
      ];
    };
    startPlugins.forModule = {
      telescope = with pkgs.vimPlugins; [
        neorg-telescope
      ];
    };
  };
}

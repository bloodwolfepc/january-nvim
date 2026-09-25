{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        neorg
        neorg-interim-ls
      ];
    };
    startPlugins.forModule = {
      telescope = with pkgs.vimPlugins; [
        neorg-telescope
      ];
    };
  };
}

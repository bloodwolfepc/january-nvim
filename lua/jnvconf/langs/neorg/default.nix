{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        neorg
        neorg-interim-ls
        neorg-telescope
      ];
      forModule = {
        telescope = with pkgs.vimPlugins; [
          neorg-telescope
        ];
      };
    };
  };
}

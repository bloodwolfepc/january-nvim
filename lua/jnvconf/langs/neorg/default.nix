{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        neorg
        neorg-interim-ls
      ];
      forModule = {
        treesitter = with pkgs.vimPlugins; [
          neorg-telescope
        ];
      };
    };
  };
}

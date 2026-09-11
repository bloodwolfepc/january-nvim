{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        gitsigns-nvim
      ];
    };
  };
}

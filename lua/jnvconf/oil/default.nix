{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        oil-nvim
      ];
    };
  };
}

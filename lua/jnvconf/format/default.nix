{ pkgs, ... }:
{
  install = {
    optPlugins.always = with pkgs.vimPlugins; [
      conform-nvim
    ];
  };
}

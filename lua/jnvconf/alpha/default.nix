{ pkgs, ... }:
{
  install.startPlugins.always = with pkgs.vimPlugins; [
    alpha-nvim
  ];
}

{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];
    };
  };
}

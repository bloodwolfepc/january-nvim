{ pkgs, ... }:
{
  install = {
    optPlugins = {
      forModule.debug = with pkgs.vimPlugins; [
        nvim-dap-python
      ];
    };
  };
}

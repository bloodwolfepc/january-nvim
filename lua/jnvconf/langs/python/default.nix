{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        pyright
      ];
    };
    optPlugins = {
      forModule.debug = with pkgs.vimPlugins; [
        nvim-dap-python
      ];
    };
  };
}

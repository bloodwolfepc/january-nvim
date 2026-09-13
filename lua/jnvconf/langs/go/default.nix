{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        gopls
      ];
    };
    optPlugins = {
      forModule.debug = with pkgs.vimPlugins; [
        nvim-dap-go
      ];
    };
  };
}

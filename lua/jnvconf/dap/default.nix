{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
      ];
      forModule = {
        telescope = with pkgs.vimPlugins; [
          telescope-dap-nvim
        ];
      };
    };
  };
}

{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text

        nvim-dap-go
        nvim-dap-python
      ];
      forModule = {
        telescope = with pkgs.vimPlugins; [
          telescope-dap-nvim
        ];
      };
    };
  };
}

{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        marksman
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        vimwiki
        markdown-preview-nvim
        render-markdown-nvim
      ];
    };
  };
}

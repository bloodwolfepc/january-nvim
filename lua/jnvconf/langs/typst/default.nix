{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        typst
        tinymist
        typst-live
        typstyle
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        typst-preview-nvim
      ];
    };
  };
}

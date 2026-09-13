{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        texlab
        texliveInfraOnly
        texlivePackages.latexmk
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        vimtex
      ];
      forModule = {
        blink = with pkgs.vimPlugins; [
          blink-cmp-latex
        ];
      };
    };
  };
}

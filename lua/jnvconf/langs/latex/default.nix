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
    };
  };
}

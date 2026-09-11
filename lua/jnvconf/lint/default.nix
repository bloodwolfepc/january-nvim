{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        eslint
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-lint
      ];
    };
  };
}

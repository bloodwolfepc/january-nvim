{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        cargo
        rustc
        rust-analyzer
        rustfmt
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        rustaceanvim
      ];
    };
  };
}

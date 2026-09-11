{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        stdenv.cc.cc
        ripgrep
        fd
        universal-ctags
        zoxide
        gh
        chez
        git
        imagemagick
        (pkgs.aspellWithDicts (
          ds: with ds; [
            en
            en-computers
          ]
        ))
      ];
    };
    startPlugins = {
      always = with pkgs.vimPlugins; [
        lz-n
      ];
    };
  };
}

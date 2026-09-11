{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        lua-language-server
        stylua
      ];
    };
  };
}

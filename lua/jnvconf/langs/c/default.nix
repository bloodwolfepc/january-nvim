{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        cmake-language-server
        clang-tools # includes clangd
      ];
    };
  };
}

{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        bash-language-server
        cmake-language-server
        clang-tools # includes clangd
      ];
    };
  };
}

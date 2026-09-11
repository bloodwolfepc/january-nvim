{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        awk-language-server
        yaml-language-server
        vscode-langservers-extracted

        cargo

        pyright
        harper
        racket
        gopls
        phpactor

        akkuPackages.akku
        akkuPackages.scheme-langserver
        scheme-manpages
        kdlfmt
        python313Packages.pylatexenc
        python312Packages.python-ly
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];
    };
  };
}

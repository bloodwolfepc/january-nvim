{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        bash-language-server
        awk-language-server
        yaml-language-server
        racket
        harper
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint

        akkuPackages.akku
        akkuPackages.scheme-langserver
        scheme-manpages

        kdlfmt
      ];
    };
  };
}

# ctags lsp
# phpactor

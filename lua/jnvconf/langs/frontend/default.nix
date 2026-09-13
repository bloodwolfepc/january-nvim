{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        emmet-ls
        tailwindcss-language-server
        typescript-language-server # TS/JS
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      ];
    };
  };
  optPlugins = {
    forModule = {
      coc = with pkgs.vimPlugins; [
        coc-tailwindcss
      ];
    };
  };
}

# css-variables-language-server
# csskit
# javascript-typescript-langserver
# vtsls
# https://github.com/blopker/codebook
# eslint # Provided with vscode-langservers-extracted
# angular-language-server
# vuels

# always = with pkgs.vimPlugins; [
#   # tailwind-tools-nvim
#   # nvim-vtsls
# ];

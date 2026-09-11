{ pkgs, ... }:
{
  install.optPlugins.always = with pkgs.vimPlugins; [
    blink-cmp
    blink-cmp-dictionary
    blink-cmp-words
    blink-cmp-spell
    blink-cmp-latex
    blink-cmp-git
    blink-cmp-avante
    blink-cmp-yanky
    blink-emoji-nvim
    blink-cmp-latex
    luasnip
    friendly-snippets
    lspkind-nvim
    luasnip-latex-snippets-nvim
  ];
}

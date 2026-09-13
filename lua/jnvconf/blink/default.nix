{ pkgs, ... }:
{
  install.optPlugins.always = with pkgs.vimPlugins; [
    blink-cmp
    blink-cmp-dictionary
    blink-cmp-words
    blink-cmp-spell
    blink-cmp-git
    blink-emoji-nvim
    blink-cmp-yanky
    blink-cmp-latex
    #TODO: Needs setup
    luasnip
    friendly-snippets
    lspkind-nvim
    luasnip-latex-snippets-nvim
  ];
}

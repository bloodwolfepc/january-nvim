{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-treesitter-textobjects
        nvim-ts-autotag # Automatically closes and renames HTML/JSX/TSX tags
        nvim-ts-context-commentstring
        comment-nvim
        todo-comments-nvim
      ];
      forModule = {
        langs = {
          markdown = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            markdown
            markdown_inline
          ];
        };
      };
    };
  };
}

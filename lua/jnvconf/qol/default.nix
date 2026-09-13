{ pkgs, extraPkgs, ... }:
{
  install = {
    startPlugins = {
      always =
        with pkgs.vimPlugins;
        [
          which-key-nvim
          vim-tmux-navigator
          tmux-nvim
          plenary-nvim
          image-nvim
          typst-preview-nvim
          vim-table-mode
          snacks-nvim
          zellij-nav-nvim
          yanky-nvim
          text-case-nvim
        ]
        ++ [ extraPkgs.fcitx-nvim ]; # lualib
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        #persistence-nvim
        #wilder-nvim
        #coc-vimtex
        #trouble-nvim
        indent-blankline-nvim
        undotree
        vim-startuptime
        fidget-nvim
        lualine-nvim
        nvim-web-devicons
        nvim-colorizer-lua
        vim-illuminate
        marks-nvim
        nvim-surround
        diffview-nvim
        eyeliner-nvim
        bufferline-nvim
        wrapping-nvim
        taskwiki
        lazydev-nvim
        plenary-nvim
        popup-nvim
        project-nvim
        img-clip-nvim
      ];
    };
  };
}

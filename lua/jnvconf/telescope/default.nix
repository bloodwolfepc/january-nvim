{ pkgs, ... }:
{
  install = {
    startPlugins = {
      always = with pkgs.vimPlugins; [
        telescope-nvim
        telescope-fzf-native-nvim # zf fzy
        telescope-undo-nvim
        telescope-symbols-nvim
        telescope-emoji-nvim
        telescope-github-nvim
        telescope-git-conflicts-nvim
        telescope-coc-nvim
        telescope-zoxide
        telescope-media-files-nvim
      ];
    };
  };
}

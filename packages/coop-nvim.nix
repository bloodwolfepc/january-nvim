{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "coop-nvim";
  version = "2025-04-14";

  src = fetchFromGitHub {
    owner = "gregorias";
    repo = "coop.nvim";
    rev = "d98b9c2";
    hash = "sha256-KcN9znmzfYoCWjV9vMya7zee9gAjxNnJ9ewfQKtspAQ";
  };

  meta = with lib; {
    description = "Neovim feed reader, rss, atom and jsonfeed, all in lua";
    homepage = "https://github.com/gregorias/coop.nvim";
    license = licenses.gpl3;
  };
}

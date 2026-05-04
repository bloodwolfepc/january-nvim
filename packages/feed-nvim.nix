{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "feed-nvim";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "neo451";
    repo = "feed.nvim";
    rev = "v${version}";
    hash = "sha256-bTTHKA6aYpwltIvBkoQ8l9OigyrEH7Kn1eeH3nwxNuM=";
  };

  meta = with lib; {
    description = "Neovim feed reader, rss, atom and jsonfeed, all in lua";
    homepage = "https://github.com/neo451/feed.nvim?tab=readme-ov-file";
    license = licenses.gpl3;
  };
  doCheck = false;
}

{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "fcitx-nvim";
  version = "2026-07-05";

  src = fetchFromGitHub {
    owner = "h-hg";
    repo = "fcitx.nvim";
    rev = "c8543d72adf02a557722847c5d263171ec5c9bb4";
    hash = "sha256-0cxLjkg9rFtl4ISeiRlI14tDMezHQSiZIdchA2x2Yes=";
  };

  meta = with lib; {
    description = "A Neovim plugin writing in Lua to switch and restore fcitx state for each buffer.";
    homepage = "https://github.com/h-hg/fcitx.nvim";
    license = with licenses; [ mit ];
  };
}

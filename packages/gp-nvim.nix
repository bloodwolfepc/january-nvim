{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "gp-nvim";
  version = "2024-05-04";

  src = fetchFromGitHub {
    owner = "Robitx";
    repo = "gp.nvim";
    rev = "v3.9.0";
    hash = "sha256-3tfhahQZPBYbAnRQXtMAnfwr4gH7mdjxtB8ZqrU3au4=";
  };

  meta = with lib; {
    description = "Gp.nvim (GPT prompt) Neovim AI plugin: ChatGPT sessions & Instructable text/code operations & Speech to text [OpenAI]";
    homepage = "https://github.com/Robitx/gp.nvim";
    license = with licenses; [mit];
  };
}

{
  pkgs,
  lib,
  vimUtils,
  fetchFromGitHub,
}:
vimUtils.buildVimPlugin rec {
  pname = "midi-input-nvim";
  version = "2024-19-04";

  src = fetchFromGitHub {
    owner = "niveK77pur";
    repo = "midi-input.nvim";
    rev = "cda15ed88b735c81d2a2f591a699f6266845e095";
    hash = "sha256-aNL8DBe2xQ4jTHrGc01KCCdBN1caU931CoptHzRdhzU";
  };

  meta = {
    description = "Neovim plugin for async and modal MIDI input ";
    homepage = "https://github.com/niveK77pur/midi-input.nvim";
  };
}

{ lib }:
let
  minimal = [
    "required"
    "treesitter"
    "telescope"
    "qol"
    "oil"
  ];

  regular = lib.unique (
    minimal
    ++ [
      "lsp"
      "lint"
      "alpha"
      "blink"
      "codecompanion"
      "dap"
      "conform"
      "gitsigns"
      "langs.all"
      "langs.c"
      "langs.frontend"
      "langs.nix"
      "langs.lua"
      "langs.neorg"
      "langs.typst"
    ]
  );

  lilypond = lib.unique (
    minimal
    ++ [
      "langs.lilypond"
    ]
  );

  full =
    root:
    let
      discover = import ./discover-modules.nix { inherit lib; };
    in
    map (m: builtins.concatStringsSep "." m.rel) (discover root);
in
{
  inherit
    minimal
    regular
    lilypond
    full
    ;
}

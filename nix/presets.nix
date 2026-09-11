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
      "codecompanion"
      "debug"
      "format"
      "gitsigns"
      "langs.c"
      "langs.nix"
      "langs.lua"
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

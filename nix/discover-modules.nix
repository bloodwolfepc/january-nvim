# Returns a list of attrs with file:fs path to default.nix; rel: list of module nesting
{ lib }:
root:
let
  walk =
    dir: prefix:
    let
      entries = builtins.readDir dir;
      names = builtins.attrNames entries;
      visit =
        name:
        let
          path = dir + "/${name}";
          rel = prefix ++ [ name ];
        in
        if entries.${name} == "directory" then
          (
            if builtins.pathExists (path + "/default.nix") then
              [
                {
                  inherit rel;
                  file = path + "/default.nix";
                }
              ]
            else
              [ ]
          )
          ++ walk path rel
        else
          [ ];
    in
    lib.concatMap visit names;
in
walk root [ ]
/*
  Recursively find all modules in a directory

  Cmd:
    From:
      nix eval --impure --json --expr '
      let
              pkgs = import <nixpkgs> {};
              discover = import ./nix/discover-modules.nix { lib = pkgs.lib; };
      in
              discover ./lua/jnvconf' | jq

  Output snippet:
    [
      {
        "file": "/home/bloodwolfe/src/january-nvim/lua/jnvconf/gitsigns/default.nix",
        "rel": [
          "gitsigns"
        ]
      },
      {
        "file": "/home/bloodwolfe/src/january-nvim/lua/jnvconf/langs/latex/default.nix",
        "rel": [
          "langs",
          "latex"
        ]
      },
    ]
*/

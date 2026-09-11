{
  lib,
  pkgs,
  extraPkgs,
}:
root:
let
  discover = import ./discover-modules.nix { inherit lib; };
  discovered = discover root;

  imported = map (m: {
    inherit (m) rel;
    value = import m.file { inherit pkgs lib extraPkgs; };
  }) discovered;
in
lib.foldl' (acc: m: lib.recursiveUpdate acc (lib.setAttrByPath m.rel m.value)) { } imported
/*
  Imports each file as a nix module

  Cmd:
    nix eval --impure --json --expr '
    let
      pkgs = import <nixpkgs> {};
      mkTree = import ./nix/module-tree.nix { lib = pkgs.lib; pkgs = pkgs; };
    in
      mkTree ./lua/jnvconf
    ' | jq

  Output Snipppet:
    "treesitter": {
      "install": {
        "optPlugins": {
          "always": [
            "/nix/store/lzw4g2zib6x86w80r8nxvk5yv00v0gsf-vimplugin-nvim-treesitter-textobjects-0-unstable-2026-07-19",
            "/nix/store/y3snnjfdmmxw1v49xndz96l12jlj4fgr-vimplugin-nvim-ts-autotag-0-unstable-2026-04-15",
            "/nix/store/dg1n5i80hm95yrfdj0rma9nk5bv3a4fy-vimplugin-nvim-ts-context-commentstring-0-unstable-2026-04-04",
            "/nix/store/vmlhygmxwddxszqi3g7g2sj9fdpdh474-vimplugin-comment.nvim-0.8.0-unstable-2024-06-09",
            "/nix/store/1ykdl2ailk6w9ryjjxs8ni9myhqyb23d-vimplugin-todo-comments.nvim-1.5.0"
          ],
          "forModule": {
            "markdown": [
              "/nix/store/cq75sq2dr2frw9ncjvl83d9cz35ldaii-vimplugin-nvim-treesitter-grammar-markdown-0.0.0+rev=c357072",
              "/nix/store/7v96xwls215bf8055biyxzvv46bbwgqq-vimplugin-nvim-treesitter-grammar-markdown_inline-0.0.0+rev=c357072"
            ]
          }
        },
        "startPlugins": {
          "always": [
            "/nix/store/0ns18jlhips4gsgpqma9rdxykfj6fp61-vimplugin-nvim-treesitter-0.10.0-unstable-2026-07-26"
          ]
        }
      }
    }
  }
*/

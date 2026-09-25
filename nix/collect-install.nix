{ lib }:
let
  collectSection =
    section: enabledPaths:
    let
      collectForModule =
        path: value:
        if builtins.isList value then
          if enabledPaths.${builtins.concatStringsSep "." path} or false then value else [ ]
        else if builtins.isAttrs value then
          lib.concatLists (lib.mapAttrsToList (name: collectForModule (path ++ [ name ])) value)
        else
          [ ];
    in
    lib.unique (
      (section.always or [ ])
      ++ lib.concatLists (lib.mapAttrsToList (name: collectForModule [ name ]) (section.forModule or { }))
    );
in
collectSection

/*
  Determine which plugins to install baesed off of enbaledPaths

  Input:
    One install section
    Set of enabled module paths

  Output:
    Flat list of values to install

  Input:
    section = {
      always = [ "nvim-treesitter" ];
      forModule.langs = {
        go = [ "nvim-treesitter-go" ];
        python = [ "nvim-treesitter-python" ];
      };
    };
    enabledPaths = {
      "langs.go" = true;
    };

  Output:
    [
      "nvim-treesitter"
      "nvim-treesitter-go"
    ]
*/

{ lib }:
let
  collectSection =
    modulePath: section: enabledPaths:
    let
      moduleName = builtins.concatStringsSep "." modulePath;
      moduleOn = enabledPaths.${moduleName} or false;

      always = if moduleOn then (section.always or [ ]) else [ ];
      children = section.forModule or { };

      collectChild =
        childName: childValue:
        let
          childPath = modulePath ++ [ childName ];
          childNameStr = builtins.concatStringsSep "." childPath;
          childOn = enabledPaths.${childNameStr} or false;
        in
        if builtins.isList childValue then
          if moduleOn && childOn then childValue else [ ]
        else if builtins.isAttrs childValue then
          collectSection childPath childValue enabledPaths
        else
          [ ];
    in
    lib.unique (always ++ lib.concatLists (lib.mapAttrsToList collectChild children));
in
collectSection

/*
  Determine which plugins to install baesed off of enbaledPaths

  Input:
    Current module path
    One install section
    Set of enabled moule paths

  Output:
    Flat list of values to install

  Input:
    modulePath = [ "langs" ];
    section = {
      always = [ "nvim-lspconfig" ];
      forModule = {
        go = [ "nvim-dap-go" ];
        python = [ "nvim-dap-python" ];
      };
    };
    enabledPaths = {
      "langs" = true;
      "langs.go" = true;
    };

  Output:
    [
      "nvim-lspconfig"
      "nvim-dap-go"
    ]
*/

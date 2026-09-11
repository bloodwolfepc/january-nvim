{ lib }:
enabledModules:
lib.foldl' (
  acc: path: lib.recursiveUpdate acc (lib.setAttrByPath (lib.splitString "." path) true)
) { } enabledModules

/*
  Convert list to attrs which are true

  Input:
    [ "langs.go" "telescope" "required" ]

  Output:
    {
      langs = {
        go = true;
      };
      telescope = true;
      required = true;
    }
*/

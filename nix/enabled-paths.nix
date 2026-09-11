{ lib }:
enabledModules:
lib.listToAttrs (
  map (path: {
    name = path;
    value = true;
  }) enabledModules
)
/*
  Convert a list of enabled module names into a lookup table

  Input:
    [
      "langs.go"
      "telescope"
      "required"
    ]

  Output:
    {
      "langs.go" = true;
      "telescope" = true;
      "required" = true;
    }
*/

{
  lib,
  pkgs,
  enabledModules,
  extraPkgs,
}:
let
  root = ../lua/jnvconf;

  loaderPlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "jnvim-loader";
    version = "unstable";
    src = ../plugins/loader;
  };

  discover = import ./discover-modules.nix { inherit lib; };
  moduleTree = import ./module-tree.nix { inherit lib pkgs extraPkgs; } root;
  discovered = discover root;

  enabledPaths = import ./enabled-paths.nix { inherit lib; } enabledModules;

  enabledModulesFile = pkgs.writeText "enabled-modules.json" (builtins.toJSON enabledModules);

  collectFromModule =
    m:
    let
      moduleValue = lib.attrByPath m.rel { } moduleTree;
      install = moduleValue.install or { };
      moduleOn = enabledPaths.${builtins.concatStringsSep "." m.rel} or false;
      collect = section: if moduleOn then (section.always or [ ]) else [ ];
    in
    {
      startPlugins = collect (install.startPlugins or { });
      optPlugins = collect (install.optPlugins or { });
      runtimeDeps = collect (install.runtimeDeps or { });
    };

  collected = map collectFromModule discovered;
in
{
  inherit enabledModulesFile;

  runtimeDeps = lib.unique (lib.concatMap (x: x.runtimeDeps) collected);

  startPlugins = [ loaderPlugin ] ++ lib.unique (lib.concatMap (x: x.startPlugins) collected);

  optPlugins = lib.unique (lib.concatMap (x: x.optPlugins) collected);
}

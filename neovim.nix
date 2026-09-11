{
  pkgs,
  neovim-unwrapped,
  lib,
  runtimeDeps ? [ ],
  startPlugins ? [ ],
  optPlugins ? [ ],
  configPath,
  enabledModulesFile,
}:
let
  packageName = "nvim";

  foldPlugins = builtins.foldl' (
    acc: next: acc ++ [ next ] ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);
  optPluginsWithDeps = lib.unique (foldPlugins optPlugins);

  runtimeRoot = pkgs.runCommandLocal "nvim-runtime" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/opt/${lib.getName plugin}"
    ) optPluginsWithDeps}
  '';
in
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = runtimeDeps ++ [ neovim-unwrapped ];
  text = ''
    export JNVIM_CONFIG_PATH="${configPath}"
    export JNVIM_ENABLED_MODULES="${enabledModulesFile}"
    exec ${neovim-unwrapped}/bin/nvim \
      --cmd "set packpath^=${runtimeRoot}" \
      --cmd "set rtp^=${runtimeRoot}" \
      "$@"
  '';
}

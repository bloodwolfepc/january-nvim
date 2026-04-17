{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,
  lib,
}:
let
  packageName = "nvim";

  startPlugins = with vimPlugins; [
    lz-n
    telescope-nvim
    nvim-treesitter.withAllGrammars
  ];
  optPlugins = with vimPlugins; [
    telescope-nvim
  ];

  foldPlugins = builtins.foldl' (
    acc: next: acc ++ [ next ] ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);
  optPluginsWithDeps = lib.unique (foldPlugins optPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ln -vsfT ${./config} $out/pack/${packageName}/start/config

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}
    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/opt/${lib.getName plugin}"
    ) optPluginsWithDeps}
  '';
in

symlinkJoin {
  name = "nvim";
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --add-flags '-u' \
      --add-flags 'NORC' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
      --set-default NVIM_APPNAME nvim
  '';
  passthru = {
    inherit packpath;
  };
}

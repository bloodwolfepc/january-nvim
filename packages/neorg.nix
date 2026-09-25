{
  lua51Packages,
  vimPlugins,
  vimUtils,
}:
let
  luaPlugin =
    package: extra:
    vimUtils.buildVimPlugin (
      {
        inherit (package) pname version src;
      }
      // extra
    );
in
vimPlugins.neorg.overrideAttrs (old: {
  dependencies = (old.dependencies or [ ]) ++ [
    (luaPlugin lua51Packages.lua-utils-nvim { })
    vimPlugins.nui-nvim
    vimPlugins.nvim-nio
    (luaPlugin lua51Packages.pathlib-nvim { doCheck = false; })
    vimPlugins.plenary-nvim
  ];
})

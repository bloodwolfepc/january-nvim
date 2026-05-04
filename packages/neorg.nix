# {
#   pkgs,
#   lib,
#   vimUtils,
#   fetchFromGitHub,
# }:
# vimUtils.buildVimPlugin rec {
#   pname = "neorg";
#   version = "9.6.4";
#
#   src = fetchFromGitHub {
#     owner = "nvim-neorg";
#     repo = "neorg";
#     rev = "1f14d72aad7165eac307a2a2f6be0fb97a04b3c2";
#     hash = "sha256-pc8Oippe70bZQxrCs04AwDEJOmzrNRPR1gwASXhg8FA";
#   };
#
#   meta = {
#     homepage = "https://github.com/nvim-neorg/neorg";
#   };
# }

{
  lib,
  buildLuarocksPackage,
  fetchurl,
  fetchzip,
  lua-utils-nvim,
  luaOlder,
  nui-nvim,
  nvim-nio,
  pathlib-nvim,
  plenary-nvim,
}:
buildLuarocksPackage {
  pname = "neorg";
  version = "9.3.0-1";
  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/neorg-9.3.0-1.rockspec";
      sha256 = "14w4hbk2hhcg1va2lgvfzzfp67lprnfar56swl29ixnzlf82a9bi";
    }).outPath;
  src = fetchzip {
    url = "https://github.com/nvim-neorg/neorg/archive/v9.3.0.zip";
    sha256 = "0ifl5n8sq8bafzx72ghfrmxsylhhlqvqmxzb5258jm76qj113cd9";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [
    lua-utils-nvim
    nui-nvim
    nvim-nio
    pathlib-nvim
    plenary-nvim
  ];

  meta = {
    homepage = "https://github.com/nvim-neorg/neorg";
    description = "Modernity meets insane extensibility. The future of organizing your life in Neovim.";
    maintainers = with lib.maintainers; [ GaetanLepage ];
    license.fullName = "GPL-3.0";
  };
}

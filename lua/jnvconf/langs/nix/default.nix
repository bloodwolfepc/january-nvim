{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        manix
        nix-doc
        nixd
        nixfmt
      ];
    };
    startPlugins = {
      forModule = {
        telescope = with pkgs.vimPlugins; [
          telescope-manix
        ];
        blink = with pkgs.vimPlugins; [
          blink-cmp-nixpkgs-maintainers
        ];
      };
    };
  };
}

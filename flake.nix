{
  description = "my neovim config and plugin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    lilypond-midi-input.url = "github:niveK77pur/lilypond-midi-input";
  };

  outputs =
    {
      self,
      nixpkgs,
      neorg-overlay,
      ...
    }@inputs:
    let

      inherit (self) outputs;
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          nixpkgs.overlays = [
            neorg-overlay.overlays.default
            (final: prev: {
              vimPlugins = prev.vimPlugins // {
                typst-preview-nvim = prev.vimPlugins.typst-preview-nvim.overrideAttrs (old: {
                  postPatch = ''
                    sed -i "s/'--no-open',/'--no-open',\n    '--verbose',/" lua/typst-preview/servers/factory.lua
                  '';
                });
              };
            })
          ];
        }
      );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        rec {
          nvim = pkgs.callPackage ./neovim.nix { inherit extraPackages; };
          extraPackages = import ./packages { inherit pkgs; };
          default = nvim;
          neorg = extraPackages.neorg;
        }
      );
    };
}

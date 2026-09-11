{
  description = "my neovim config and plugin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";
    lilypond-midi-input.url = "github:niveK77pur/lilypond-midi-input";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      neorg-overlay,
      flake-utils,
      home-manager,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            neorg-overlay.overlays.default
          ];
        };
        extraPkgs = import ./packages { inherit pkgs; };

        lib = pkgs.lib;
        presets = import ./nix/presets.nix { inherit lib; };

        mkNvim =
          enabledModules:
          let

            install = import ./nix/module.nix {
              inherit
                lib
                pkgs
                enabledModules
                extraPkgs
                ;
            };
          in
          pkgs.callPackage ./neovim.nix {
            runtimeDeps = install.runtimeDeps;
            startPlugins = install.startPlugins;
            optPlugins = install.optPlugins;
            configPath = ./.;
            enabledModulesFile = install.enabledModulesFile;
          };

        minimal = mkNvim presets.minimal;
        regular = mkNvim presets.regular;
        lilypond = mkNvim presets.lilypond;
        full = mkNvim (presets.full ./lua/jnvconf);
      in
      {
        packages = {
          inherit
            minimal
            regular
            lilypond
            full
            ;
          default = minimal;
        };

        apps.default = {
          type = "app";
          program = "${minimal}/bin/nvim";
        };

        homeManagerModules.default = import ./nix/home-manager-module.nix;
      }
    );
}

{
  pkgs ? import <nixpkgs>,
}:
rec {
  gp-nvim = pkgs.callPackage ./gp-nvim.nix { };
  neorg = pkgs.callPackage ./neorg.nix { };
  feed-nvim = pkgs.callPackage ./feed-nvim.nix { };
  coop-nvim = pkgs.callPackage ./coop-nvim.nix { };
  midi-input-nvim = pkgs.callPackage ./midi-input-nvim.nix { };
}

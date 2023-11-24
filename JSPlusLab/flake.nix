{
  description = "Javascript and its ecosystem projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        seoulVimColor = pkgs.fetchFromGitHub {
          owner = "junegunn";
          repo = "seoul256.vim";
          rev = "master";
          sha256 = "sha256-PHplqWYT9sxU/Z/U+bRfCqiCOITjTp1T3xytZBBgQy4=";
        };
        materialVimColor = pkgs.fetchFromGitHub {
          owner = "jdkanani";
          repo = "vim-material-theme";
          rev = "master";
          sha256 = "sha256-2y4G2mqMrArg+bMI3xJsv6SzELSuO64JlzjjHIX/uz8=";
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_20
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${materialVimColor}:${seoulVimColor}"
            export PROJECT_NVIM_CONFIG=${luaNeovimLab}
          '';
        };
      });
}

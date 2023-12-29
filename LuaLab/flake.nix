{
  description = "Lua projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        neovdevPlugin = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "neodev.nvim";
          rev = "main";
          sha256 = "sha256-7OdEbwP4ybR59AH8qauRn+3vB48gx9++X+1cYf+0Y8c=";
        };
        nvimProjectLab = pkgs.fetchFromGitHub {
          name = "nvim-lua-config";
          owner = "mononosis";
          repo = "nvim-lua-config";
          rev = "main"; 
          sha256 = "sha256-8tQaFkTtrc/yRKbx1GctEHt5Aie0oS72T4EZODS46qE="; 
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.lua-language-server
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${neovdevPlugin}"
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimProjectLab.repo} \
                || export PROJECT_NVIM_CONFIG=${nvimProjectLab}
          '';
        };
      });
}

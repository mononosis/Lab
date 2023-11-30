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
        plenaryPlugin = pkgs.fetchFromGitHub {
          owner = "nvim-lua";
          repo = "plenary.nvim";
          rev = "master";
          sha256 = "sha256-WBrhQ/sRSnxuY16vxnwASMkXPlWvNFPa6iitsvh2e3A=";
        };
        neovdevPlugin = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "neodev.nvim";
          rev = "main";
          sha256 = "sha256-WBrhQ/sRSnxuY16vxnwASMkXPlWvNFPa6iitsvh2e3A=";
        };
        # Fetch the Lua configuration file directly from GitHub
        luaNeovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-lua-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-E3EHFIRN5zBMDbqCB+sY5qyA6Xw0RYsYGVBJjtF6CtA="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.lua-language-server
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${materialVimColor}:${plenaryPlugin}:${neovdevPlugin}:${seoulVimColor}"
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${luaNeovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${luaNeovimLab}
          '';
        };
      });
}

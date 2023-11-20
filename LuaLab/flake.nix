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
          repo = "lua-neovim-lab";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-wAcgJHrNbLwwrwsTS2A0+PtlyVwswJarEtrQQBaaNs0="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.lua-language-server
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS="${plenaryPlugin}:${neovdevPlugin}"
            export PROJECT_NVIM_CONFIG=${luaNeovimLab}
          '';
        };
      });
}

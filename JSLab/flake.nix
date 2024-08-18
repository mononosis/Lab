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
        materialVimColor = pkgs.fetchFromGitHub {
          owner = "Rigellute";
          repo = "shades-of-purple.vim";
          rev = "master";
          sha256 = "sha256-iiGASgVlIXnnUNBlp9viKgDBfHiOP5P/yJx9XyELT9g=";
        };
        neovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-jsplus-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-cW5tcVrTcXWHT5BGBKOp2SiXETR4fmokjZ6r+SLxVOQ="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_18
            pkgs.nodePackages.typescript-language-server
            pkgs.nodePackages.vscode-html-languageserver-bin
            pkgs.nodePackages.typescript
            pkgs.nodePackages.pnpm
            pkgs.yarn
            pkgs.openssl
          ];
          shellHook = ''
            export NODE_OPTIONS=--openssl-legacy-provider
            export NVIM_PLUGIN_PATHS="${materialVimColor}"
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${neovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${neovimLab}
          '';
        };
      });
}

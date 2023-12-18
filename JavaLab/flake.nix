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
        # Fetch the Lua configuration file directly from GitHub
        neovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-java-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = ""; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.lua-language-server
          ];
          shellHook = ''
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${neovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${neovimLab}
          '';
        };
      });
}

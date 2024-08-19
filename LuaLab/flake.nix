{
  description = "Lua projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimProjectLab = pkgs.fetchFromGitHub {
          name = "nvim-lua-config";
          owner = "mononosis";
          repo = "nvim-lua-config";
          rev = "main";
          sha256 = "sha256-DsWKyMYYkOSc3jnfiBrECmV/Addlxrt1PX22xGsHHZY=";
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.lua-language-server
            pkgs.lua54Packages.lua
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimProjectLab.repo} \
                && export XDG_CONFIG_HOME=/home/nixos/.config/home-manager \
                || export PROJECT_NVIM_CONFIG=${nvimProjectLab}
          '';
        };
      });
}

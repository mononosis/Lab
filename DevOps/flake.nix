{
  description = "eks jenkins and so on";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        neovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-python-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-I9HvQAzDR0SfeihK0Dwpz4pjNS7UVsI+5WLHDut/0K0="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            wrapGAppsHook
          ];
          buildInputs = with pkgs; [
            kubernetes-helm
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${neovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${neovimLab}

          '';
        };
      });
}

{
  description = "Haskell projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvimHaskellLab = pkgs.fetchFromGitHub {
          name = "nvim-haskell-config";
          owner = "mononosis";
          repo = "nvim-haskell-config";
          rev = "main";
          sha256 = "sha256-dC6YS3gNcwECZ7/+GKts5asb9zK/4bfXxRJ5lGf66xQ=";
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs;[
            #haskell-language-server
            haskell.compiler.ghc964
            zlib
            (
              haskell-language-server.override { supportedGhcVersions = [ "964" "94" ]; }
            )

            #haskellPackages.haskell-language-server
            haskellPackages.stack
            ormolu

          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode ${nvimHaskellLab.repo}" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${nvimHaskellLab.repo} \
                && export XDG_CONFIG_HOME=/home/nixos/.config/home-manager \
                || export PROJECT_NVIM_CONFIG=${nvimHaskellLab}
          '';
        };
      });
}

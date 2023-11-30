{
  description = "Python and its ecosystem projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonNeovimLab = pkgs.fetchFromGitHub {
          owner = "mononosis";
          repo = "nvim-python-config";
          rev = "main"; # Use the appropriate commit or tag
          sha256 = "sha256-UF6yCKSBZ3NDDB+q8kYHSljO+3HeE78Stz8ukHTrjsA="; # Replace with the correct hash
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            #pkgs.conda
            pkgs.python311
            pkgs.nodePackages.pyright
            pkgs.python311Packages.black
            pkgs.python311Packages.flake8
          ];
          shellHook = ''
            export NVIM_PLUGIN_PATHS=""
            [[ ! -z $NIX_DEV_MODE ]] \
                && echo "We are in dev mode" \
                && export PROJECT_NVIM_CONFIG=$HOME/Lab/LuaLab/${pythonNeovimLab.repo} \
                || export PROJECT_NVIM_CONFIG=${pythonNeovimLab}
          '';
        };
      });
}
